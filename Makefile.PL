use ExtUtils::MakeMaker;
WriteMakefile(
	NAME => "CGI",
	DISTNAME => "Mozsniff",
	VERSION => "0.05",
        linkext => { LINKTYPE => '' },
        dist => {COMPRESS=>'gzip -9f', SUFFIX => 'gz'},
);
