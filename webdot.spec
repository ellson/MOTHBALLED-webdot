Name:           webdot
Version:        1.7.1
Release:        1
Group:          Applications/Graphics
Copyright:      BSD-style
URL:            http://www.graphviz.org/
Summary:        Graph Visualization Tools
Packager:       John Ellson (ellson@lucent.com)

Requires:       graphviz
Source:         http://www.graphviz.org/pub/graphviz/%{name}-%{version}.tar.gz

%description
A cgi-bin program that produces clickable graphs in web pages
when provided with an href to a .dot file.  Uses Tcldot from the
graphviz rpm.

%prep

%setup -n %{name}-%{version}

# %define cgibindir %(rpm -ql apache | grep '/cgi-bin$')
# %define htmldir   %(rpm -ql apache | grep '/html$')

%install
make install
%{?suse_check}

%files
%attr(-,root,root) /var/www/cgi-bin/webdot
%attr(-,root,root) /var/www/html/webdot/
%attr(-,apache,apache) /var/cache/webdot/
