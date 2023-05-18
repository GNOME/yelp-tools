#include <gio/gio.h>
#include <glib.h>
#include <glib/gstdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include "org.freedesktop.portal.Documents.h"

#define BASE_PATH "/usr/share/help/C"
#define CACHE_PATH "yelp-build/C"
#define DOCUMENTS_DBUS_INTERFACE "org.freedesktop.portal.Documents"
typedef enum
{
  DOCUMENTS_ADD_FLAG_REUSE_EXISTING = 1,
  DOCUMENTS_ADD_FLAG_PERSISTENT = 2,
  DOCUMENTS_ADD_FLAG_AS_NEEDED_BY_APP = 4,
  DOCUMENTS_ADD_FLAG_EXPORT_DIRECTORY = 8,
} PortalDocumentsAddFlags;

static gboolean
generate_html (const char *source_dir,
               const char *output_dir)
{
        g_autoptr(GError) error = NULL;
        const char *argv[] = { "yelp-build", "html", ".", "-o", output_dir, NULL };

        if (g_mkdir_with_parents (output_dir, 0755) == -1) {
                g_printerr ("Failed to create directory: %s\n", output_dir);
                return 1;
        }

        g_spawn_sync (source_dir,
                      (char **) argv,
                      NULL,
                      G_SPAWN_SEARCH_PATH | G_SPAWN_CHILD_INHERITS_STDOUT | G_SPAWN_CHILD_INHERITS_STDERR,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      &error);

        if (error != NULL) {
                g_autofree char *command_line = NULL;

                command_line = g_strjoinv (" ", (char **) argv);

                g_printerr ("Could not run '%s': %s", command_line, error->message);
                return FALSE;
        }

        return TRUE;
}

static char *
grant_access_to_browser (const char *output_dir,
                         const char *output_file)
{
        g_autoptr(GAppInfo) default_browser = NULL;
        const char *app_id = NULL;
        g_autoptr(PortalDocuments) portal_documents = NULL;
        PortalDocumentsAddFlags flags;
        g_autoptr(GUnixFDList) fd_list = NULL;
        g_autoptr(GError) error = NULL;
        const char *permissions[] = { "read", NULL };
        GVariantBuilder fds;
        g_auto (GStrv) doc_ids = NULL;
        g_autofree char *basename = NULL;
        g_autofd int dir_fd = -1;

        default_browser = g_app_info_get_default_for_type ("text/html", FALSE);
        if (default_browser == NULL) {
                g_printerr ("Default web browser not found!\n");
                return NULL;
        }

        app_id = g_app_info_get_id (default_browser);

        dir_fd = open (output_dir, O_PATH);
        if (dir_fd == -1) {
                g_printerr ("Failed to open directory %s: %m\n", output_dir);
                return NULL;
        }

        portal_documents = portal_documents_proxy_new_for_bus_sync (G_BUS_TYPE_SESSION,
                                                                    G_DBUS_PROXY_FLAGS_NONE,
                                                                    DOCUMENTS_DBUS_INTERFACE,
                                                                    "/org/freedesktop/portal/documents",
                                                                    NULL,
                                                                    &error);

        if (!portal_documents) {
                g_printerr ("Failed to create D-Bus proxy: %s\n", error->message);
                return NULL;
        }

        fd_list = g_unix_fd_list_new ();

        g_variant_builder_init (&fds, G_VARIANT_TYPE ("ah"));
        g_variant_builder_add (&fds, "h", g_unix_fd_list_append (fd_list, dir_fd, NULL));

        flags = DOCUMENTS_ADD_FLAG_REUSE_EXISTING  |
                DOCUMENTS_ADD_FLAG_PERSISTENT      |
                DOCUMENTS_ADD_FLAG_EXPORT_DIRECTORY;

        portal_documents_call_add_full_sync (portal_documents,
                                             g_variant_builder_end (&fds),
                                             flags,
                                             app_id,
                                             (const char * const *) permissions,
                                             fd_list,
                                             &doc_ids,
                                             NULL,
                                             NULL,
                                             NULL,
                                             &error);

        if (error) {
                g_printerr ("Failed to call AddFull method: %s\n", error->message);
                return NULL;
        }

        if (doc_ids[0][0] == '\0') {
                return NULL;
        }

        basename = g_path_get_basename (output_dir);
        return g_build_filename (g_get_user_runtime_dir (), "doc", doc_ids[0], basename, NULL);
}

static gboolean
show_generated_html (const char *output)
{
        g_autoptr(GError) error = NULL;
        g_autofree char *uri = NULL;

        uri = g_filename_to_uri (output, NULL, NULL);

        if (!g_app_info_launch_default_for_uri (uri, NULL, &error)) {
                g_printerr ("Failed to launch default application: %s\n", error->message);
                return FALSE;
        }

        return TRUE;
}

static char *
write_redirect_file (const char *sandboxed_dir,
                     const char *sandboxed_file)
{
        g_autofree char *html = NULL;
        g_autofree char *redirect_file = NULL;
        g_autoptr(GError) error = NULL;
        gboolean contents_set;

        html = g_strdup_printf ("<meta http-equiv=\"refresh\" content=\"0; url=%s\">",
                                sandboxed_file);
        redirect_file = g_build_filename (sandboxed_dir, "yelp-build-redirect.html", NULL);
        contents_set = g_file_set_contents(redirect_file, html, -1, &error);

        if (!contents_set) {
                g_printerr ("Error writing redirect file %s: %s\n", redirect_file, error->message);
                return NULL;
        }

        return g_steal_pointer (&redirect_file);
}

int
main (int   argc,
      char *argv[])
{
        GError *error = NULL;
        GOptionContext *context;
        char **args = NULL;
        g_autofree char *scheme = NULL;
        g_autofree char *userinfo = NULL;
        g_autofree char *host = NULL;
        g_autofree char *path = NULL;
        g_autofree char *query = NULL;
        g_autofree char *fragment = NULL;
        g_autofree char *source_dir = NULL;
        g_autofree char *output_file = NULL;
        g_autofree char *output_dir = NULL;
        g_autofree char *sandboxed_dir = NULL;
        g_autofree char *sandboxed_file = NULL;
        g_autofree char *redirect_file = NULL;
        g_autofree char *basename = NULL;
        g_autofree char *full_source_path;
        const char *url;
        gint port;

        GOptionEntry entries[] =
        {
                { G_OPTION_REMAINING, '\0', 0, G_OPTION_ARG_STRING_ARRAY, &args, NULL, "[URL]" },
                { NULL }
        };

        context = g_option_context_new ("- URL handler for Yelp-Build");
        g_option_context_add_main_entries (context, entries, "Yelp-Build URL Handler");
        if (!g_option_context_parse (context, &argc, &argv, &error)) {
                g_print ("option parsing failed: %s\n", error->message);
                exit (1);
        }

        if (args == NULL || g_strv_length (args) != 1) {
               g_printerr ("Please provide a URL.\n");
               return 1;
        }

        url = args[0];

        g_uri_split (url, G_URI_FLAGS_ENCODED, &scheme, &userinfo, &host, &port, &path, &query, &fragment, &error);

        if (g_strcmp0 (scheme, "help") != 0) {
                g_printerr ("Invalid URI scheme: %s\n", scheme);
                return 1;
        }

        full_source_path = g_build_filename (BASE_PATH, path, NULL);

        if (g_file_test (full_source_path, G_FILE_TEST_IS_DIR)) {
                source_dir = g_strdup (full_source_path);
                output_dir = g_build_filename (g_get_user_cache_dir(), CACHE_PATH, path, NULL);
                output_file = g_build_filename (output_dir, "index.html", NULL);
        } else {
                g_autofree char *incomplete_path = full_source_path;
                g_autofree char *output_path = NULL;

                full_source_path = g_strconcat (incomplete_path, ".page", NULL);
                output_path = g_strconcat (path, ".html", NULL);

                if (g_file_test (full_source_path, G_FILE_TEST_IS_REGULAR)) {
                        source_dir = g_path_get_dirname (full_source_path);
                        output_file = g_build_filename (g_get_user_cache_dir(), CACHE_PATH, output_path, NULL);
                        output_dir = g_path_get_dirname (output_file);
                }
        }

        if (output_file == NULL) {
                g_printerr ("Invalid path: %s\n", full_source_path);
                return 1;
        }

        if (!generate_html (source_dir, output_dir)) {
                g_printerr ("Failed to generate html for path %s\n", full_source_path);
                return 1;
        }

        sandboxed_dir = grant_access_to_browser (output_dir, output_file);

        if (sandboxed_dir == NULL) {
                g_printerr ("Failed to grant browser access to generated html for path %s\n", full_source_path);
                return 1;
        }

        basename = g_path_get_basename (output_file);
        sandboxed_file = g_build_filename (sandboxed_dir, basename, NULL);
        redirect_file = write_redirect_file (sandboxed_dir, sandboxed_file);

        if (show_generated_html (redirect_file)) {
                g_printerr ("Failed to start browser\n");
                return 1;
        }

        return 0;
}
