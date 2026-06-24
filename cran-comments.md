## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* The NOTE about being unable to verify the current time appears to be environment-specific.

## URL checks

`urlchecker::url_check()` reports a 403 Forbidden response for one DOI link
in README.md:

https://doi.org/10.1287/opre.2021.0792

The DOI resolves in a browser and via `curl -I` to the publisher page, but the
publisher/DOI endpoint appears to block automated URL checking. I have retained
the DOI because it is a scholarly reference for the package methodology.
