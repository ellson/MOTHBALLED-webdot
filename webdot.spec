Name:           webdot
Version:        1.7.1
Release:        1
Group:          Applications/Graphics
Copyright:      BSD-style
URL:            http://www.graphviz.org/
Summary:        A CGI graph server script that uses tcldot from graphviz.
Packager:       John Ellson (ellson@lucent.com)
Requires:       graphviz ghostscript tcl
Source:         http://www.graphviz.org/pub/graphviz/%{name}-%{version}.tar.gz
BuildArchitectures: noarch
BuildRoot:	%{_tmppath}/%{name}-root

%description
A cgi-bin program that produces clickable graphs in web pages
when provided with an href to a .dot file.  Uses Tcldot from the
graphviz rpm.

%prep
%setup -n %{name}-%{version}

%build

%define cgibindir %(rpm -ql apache | grep '/cgi-bin$')
%define htmldir   %(rpm -ql apache | grep '/html$')
%define cachedir  /var/cache/webdot
#%define tclsh8    %(rpm -ql tcl | grep tclsh8)
#%define libtcldot %(rpm -ql graphviz | grep 'libtcldot.so$')
#%define gs        %(which gs)
#%define ps2epsi   %(which ps2epsi)

%install
#rm -rf $RPM_BUILD_ROOT
#mkdir -p $RPM_BUILD_ROOT%{cgibindir}
#mkdir -p $RPM_BUILD_ROOT%{htmldir}
#mkdir -p $RPM_BUILD_ROOT/var/cache/webdot
#cp cgi-bin/webdot $RPM_BUILD_ROOT%{cgibindir}
#cp -r html/webdot $RPM_BUILD_ROOT%{htmldir}
make install
%{?suse_check}

%files
%attr(-,root,root) %{cgibindir}/webdot
%attr(-,root,root) %{htmldir}/webdot/
%attr(-,apache,apache) %{cachedir}
