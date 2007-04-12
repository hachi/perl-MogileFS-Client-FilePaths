package MogileFS::Client::FilePaths;

use strict;
use warnings;

our $VERSION = '0.00_01';
$VERSION = eval $VERSION;

use base 'MogileFS::Client';

sub list {
    my $self = shift;
    my $path = shift;
    return unless defined $path && length $path;
    my $dir = $self->SUPER::filepaths_list_directory($path);
    return unless $dir;

    $path =~ s!/?$!/!; # Make sure there's a / on the end of the path

    my $filecount = $dir->{files};
    return unless $filecount and $filecount > 0;

    my @ret;

    for (my $i = 0; $i < $filecount; $i++) {
        my $prefix = "file$i";
        my %nodeinfo;

        my $name = $nodeinfo{name} = $dir->{$prefix};
        $nodeinfo{path} = $path . $name;
        if ($dir->{"$prefix.type"} eq 'D') {
            $nodeinfo{is_directory} = 1;
        } else {
            $nodeinfo{is_file} = 1;
            my $mtime = $dir->{"$prefix.mtime"};
            $nodeinfo{modified} = $mtime if $mtime;
            $nodeinfo{size} = $dir->{"$prefix.size"};
        }

        push @ret, \%nodeinfo;
    }

    return @ret;
}

1;
