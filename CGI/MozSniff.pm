package CGI::MozSniff;

# This needs work, especially on the regexps.
# Copyleft 1997, Jason Costomiris <jcostom@sjis.com>

$CGI::MozSniff::VERSION = '0.07';

require 5.003;
require Exporter;

# to satisfy strict, we use my vars...
@ISA = qw(Exporter);
@EXPORT = qw(new sniff);
my $i = 0;

sub new {
	# Used to instantiate the object.
	my $class = shift;
	return bless {}, $class;
}

sub sniff {
	# Exported sub to check browser versions.
	# Mozilla and IE friendly.  We can even spot the IE/AOL mess.
	#
	my $self = shift;
	my $ua = $ENV{HTTP_USER_AGENT};
	# Make it CLI/passed param friendly for testing.
	$ua ||= shift;
	if ($ua =~ /Mozilla/) {
		my $ver = &ns_ver($ua);
		if ($ver >= 4) {
			if ($ua =~ /MSIE/) {
				my $navtype = $ua;
				$navtype =~ s/.*\(//;
				$navtype =~ s/\).*//;
				my @nav = split(/;/, $navtype);
				for ($i = 0 ; $i<=$#nav ; $i++){
					$nav[$i] =~ s/^\s//;
					$nav[$i] =~ s/\s$//;
				}
				my $msie = $nav[1];
				$msie =~ s/^MSIE //;
				return("msie\_$msie");
			}
			my $navtype = &ns4_type($ua);
			$navtype =~ tr/A-Z/a-z/;
			return("$navtype\_$ver");
		} elsif ($ver >= 3) {
			if ($ua =~ /Opera/) {
				my $navtype = $ua;
				$navtype =~ s/.*\(//;
				$navtype =~ s/\).*//;
				my @nav = split(/;/, $navtype);
				for ($i = 0 ; $i<=$#nav ; $i++){
					$nav[$i] =~ s/^\s//;
					$nav[$i] =~ s/\s$//;
				}
				$_ = $nav[1];
				/Opera\//;
				my $opera = $';
				return("opera\_$opera");
			} else {
				return("navigator\_$ver");
			}
		} elsif ($ver >= 2) {
			if ($ua =~ /MSIE/) {
				my $navtype = $ua;
				$navtype =~ s/.*\(//;
				$navtype =~ s/\).*//;
				my @nav = split(/;/, $navtype);
				for ($i = 0 ; $i<=$#nav ; $i++){
					$nav[$i] =~ s/^\s//;
					$nav[$i] =~ s/\s$//;
				}
				my $msie = $nav[1];
				$msie =~ s/^MSIE //;
				if ($ua =~ /AOL/) {
					return("msie\_$msie\_AOL");
				} else {
					return("msie\_$msie");
				}
			} else {
				return("navigator\_$ver $ua");
			}
		}
	} else {
		# Yeesh.  I need to get some other browsers in here.
		return("other");
	}
		
}

sub ns_ver {
	# Internal sub to rip out the Mozilla version number.
	my $ver = shift;
	$ver =~ s/Mozilla\///;
	$ver =~ s/\s.*//;
	return($ver);
}

sub ns4_type {
	# Figure out if it's Navigator 4.x or Communicator 4.x
	my $navtype = shift;
	$navtype =~ s/.*\(//;
	$navtype =~ s/\).*//;
	my @nav = split(/;/, $navtype);
	for ($i = 0 ; $i<=$#nav ; $i++){
		$nav[$i] =~ s/^\s//;
		$nav[$i] =~ s/\s$//;
	}
	if ($nav[2] =~ /Nav/) {
		return("navigator");
	} else {
		return("communicator");
	}
}


1;
__END__

=head1 NAME

B<MozSniff> - Sniff out various versions of browsers claming to be "Mozilla".

=head1 SYNOPSIS

I got tired of redoing this several times, or using CGI::user_agent(), so I wrote my own.

=head1 DESCRIPTION

You should be able, I hope, to do something like:

	use CGI::MozSniff;
	my $foo = new CGI::MozSniff;
	my $bar = $foo->sniff;

Values for $foo->sniff are:

=over 4

=item *
navigator_B<$ver> - Netscape Navigator v.B<$ver>

=item *
communicator_B<$ver> - Netscape Communicator v.B<$ver>

=item *
msie_B<$ver> - Microsoft Internet Explorer v.B<$ver>

=item *
msie_B<$ver>_AOL - Microsoft Internet Explorer v.B<$ver> (AOL)

=item *
opera_B<$ver> - Opera, a pretty nice browser, as far as Windoze browsers go...

=item *
other - Some other browser

=back

=cut
