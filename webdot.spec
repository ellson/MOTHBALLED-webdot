Name:           webdot
Version:        1.8.9
Release:        0_RH7
Group:          Applications/Graphics
License:        BSD-style
URL:            http://www.graphviz.org/
Summary:        A CGI graph server script that uses tcldot from graphviz-tcl.
Packager:       John Ellson (ellson@lucent.com)
Requires:       graphviz-tcl ghostscript tcl
Source:         http://www.graphviz.org/pub/graphviz/%{name}-%{version}.tar.gz
BuildArchitectures: noarch
BuildRoot:	%{_tmppath}/%{name}-root

%description
A cgi-bin program that produces clickable graphs in web pages
when provided with an href to a .dot file.  Uses Tcldot from the
graphviz-tcl rpm.

%prep
%setup -n %{name}-%{version}

%define cgibindir  %(rpm -ql apache | grep -v doc | grep '/cgi-bin$')
%define htmldir    %(rpm -ql apache | grep -v doc | grep '/html$')
%define httpdconf  %(rpm -ql apache | grep -v doc | grep '/httpd\\\.conf$')
%define apacheuser %(grep -i '^user ' %{httpdconf} | awk '{print $2}')
%define apachegroup %(grep -i '^group ' %{httpdconf} | awk '{print $2}')

%define cachedir   /var/cache/webdot
%define tclshbin   %(rpm -ql tcl | grep '/tclsh$')
%define tcldotlib  %(rpm -ql graphviz-tcl | grep '/libtcldot\\\.so$')
%define gsbin      %(which gs)
%define ps2epsibin %(which ps2epsi)

%install
mkdir -p $RPM_BUILD_ROOT/%{cgibindir}
mkdir -p $RPM_BUILD_ROOT/%{htmldir}
mkdir -p $RPM_BUILD_ROOT/%{cachedir}
cp $RPM_SOURCE_DIR/cgi-bin/webdot $RPM_BUILD_ROOT/%{cgibindir}/
cp -r $RPM_SOURCE_DIR/html/webdot $RPM_BUILD_ROOT/%{htmldir}/
chown %{apacheuser}:%{apachegroup} $RPM_BUILD_ROOT/%{cachedir}
chmod 700 $RPM_BUILD_ROOT/%{cachedir}
%{?suse_check}

%files
%attr(755,root,root) %{cgibindir}/webdot
%attr(-,root,root) %{htmldir}/webdot/
%attr(700,%{apacheuser},%{apachegroup}) %{cachedir}/

%post
cat > %{cgibindir}/webdot.new << '__EOF__'
#!%{tclshbin}
set LIBTCLDOT %{tcldotlib}
set CACHE_ROOT %{cachedir}
set GS %{gsbin}
set PS2EPSI %{ps2epsibin}
set LOCALHOSTONLY 1
__EOF__
cat %{cgibindir}/webdot >> %{cgibindir}/webdot.new
mv -f %{cgibindir}/webdot.new %{cgibindir}/webdot
chmod +x %{cgibindir}/webdot
chown %{apacheuser}:%{apachegroup} %{cachedir}
chmod 700 %{cachedir}

%clean
rm -rf $RPM_BUILD_ROOT
