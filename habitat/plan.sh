pkg_name=planet-static
pkg_origin=smacfarlane
pkg_version="0.1.0"
pkg_scaffolding="core/scaffolding-node"
pkg_deps=(core/nginx)
pkg_svc_run="nginx -c ${pkg_svc_config_path}/nginx.conf"
pkg_svc_user="root"
pkg_svc_group="root"
pkg_exports=(
  [port]=http.listen.port
  )
pkg_exposes=(port)

# We need to copy a few additional files into the cache
do_prepare() {
	do_default_prepare
	cp -a "./src" "${CACHE_PATH}/"
	cp -a "./webpack.config.js" "${CACHE_PATH}/"
	cp -a "./public" "${CACHE_PATH}/"
  # Unset this so that `node_modules` and `bin` don't end up in the resulting package as they're not needed for this package
	pkg_bin_dirs=()
}

# Override do_build to only call scaffolding_modules_install
#  scaffolding_(fix_node_shebangs|setup_app_config) aren't needed for static sites for this example. 
#
# Possibly this should be do_prepare in the context of a static site, but to keep consistancy with the existing scaffolding it lives here. 
do_build() {
	scaffolding_modules_install
}

# Override do_install to run webpack to generate our bundle.
#  This could also live in do_build without --output-path specified and do_install would change to be a copy of `dist`. 
#  This would require knowledge of what `outputPath` is set to in webpack.config.js though.
do_install() {
	install -m 0644 index.html $pkg_prefix/
	pushd $CACHE_PATH >/dev/null
	$(npm bin)/webpack --output-path="${pkg_prefix}/dist"
	popd > /dev/null
}

