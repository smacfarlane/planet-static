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

do_prepare() {
	do_default_prepare
	cp -a "./index.html" "${CACHE_PATH}/"
	cp -a "./src" "${CACHE_PATH}/"
	cp -a "./webpack.config.js" "${CACHE_PATH}/"
	cp -a "./public" "${CACHE_PATH}/"
	pkg_bin_dirs=()
}

do_build() {
	scaffolding_modules_install
}

do_install() {
	install -m 0644 index.html $pkg_prefix/
	pushd $CACHE_PATH >/dev/null
	$(npm bin)/webpack --output-path="${pkg_prefix}/dist"
	popd > /dev/null
}

