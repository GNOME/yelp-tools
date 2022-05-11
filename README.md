# Yelp Tools

yelp-tools is a collection of scripts and build utilities to help create,
manage, and publish documentation for Yelp and the web. Most of the heavy
lifting is done by packages like yelp-xsl and itstool. This package just
wraps things up in a developer-friendly way.


## ORGANIZATION

- `templates/`
        The templates directory contains page templates used by yelp-new.

- `tools/`
        The tools directory contains scripts like yelp-build and yelp-check,
        as well as the yelp.m4 file that provides autotools integration.

- `xslt/`
	The xslt directory contains small utility XSLT files that are used
        by the various scripts shipped with yelp-tools. These stylesheets
        are not intended to be built upon.
