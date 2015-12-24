An example [Rcpp][1] Plugin Package
-------------------

__This is only an example of ad-hoc sourceCpp usage.__

Todo:

- [ ] Properly handle `setHook` so it doesn't continuously append.
- [ ] Properly handle path identification to work with packages.

----

Dependency:

Google Performance Tools aka [gperftools][2]

    sudo apt-get -y install google-perftools libgoogle-perftools-dev

Installation:

Using [devtools][3]:

    devtools::install_github("thell/PluginGPerf")

Usage:

Add `PluginGperf` to your `cpp` files plugins [attributes][5]...

    \\ [Rcpp::plugins(PluginGperf)]

Do the plugin registration:  
(see Rcpp [PR #409][4] that eliminates this requirement)

    PluginGperf::register.plugin()

Source your file:

    file <- system.file("examples/gperf-test.cpp", package = "PluginGperf")
    Rcpp::sourceCpp(file)
    
Sample output:

    Execute profiling function then in a shell run:
     google-pprof --web /tmp/RtmphOaX5C/sourcecpp_2d2c1fa052f1/sourceCpp_2.so gprof.out

Execute profiling function (we need a big number and want to hide the output):

    invisible(gperf(1:6000000))
    
Sample output:

    PROFILE: interrupts/evictions/bytes = 4/0/720

You can now see the `gprof.out` file in the working directory and can issue a
`google-pprof` command on it using the library file in the `RtmpXXX` path.

[1]:https://github.com/RcppCore/Rcpp
[2]:https://github.com/gperftools/gperftools
[3]:https://github.com/hadley/devtools
[4]:https://github.com/RcppCore/Rcpp/pull/409
[5]:dirk.eddelbuettel.com/code/rcpp/Rcpp-attributes.pdf
