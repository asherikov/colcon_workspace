bp_clangd_build: assert_BASE_BUILD_PROFILE_must_exist
	mkdir -p "${CCWS_CACHE}/clangd/${BASE_BUILD_PROFILE}/"
	find "build/${BASE_BUILD_PROFILE}/" -name "compile_commands.json" | xargs jq -s add > "${CCWS_CACHE}/clangd/${BASE_BUILD_PROFILE}/compile_commands.json"
	# https://clangd.llvm.org/config.html
	echo "CompileFlags:" 												 		> "${WORKSPACE_DIR}/.clangd"
	echo "  CompilationDatabase: ${CCWS_CACHE}/clangd/${BASE_BUILD_PROFILE}/" 	>> "${WORKSPACE_DIR}/.clangd"
	# note: cache is created next to compile commands -> https://github.com/clangd/clangd/issues/184
	# a few notes regarding clangd-indexer
	# 	https://github.com/clangd/clangd/issues/587
	# 	https://github.com/clangd/clangd/issues/541


bp_clangd_install_build: bp_common_install_build
	# neovim:
	#
	# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	#
	# call plug#begin()
	# Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.6' }
	# call plug#end()
	#
	# :PlugInstall
	#
	# lua require'lspconfig'.clangd.setup{cmd={'clangd-12'}} >> init.vim
	# ---
	#
	# ccls:
	# compilation requirements ${APT_INSTALL} libclang-12-dev rapidjson-dev llvm-12-dev
	# https://github.com/MaskRay/ccls/wiki/Customization
	# ---
	#
	# clangd:
	# get latest -> `sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"`
	bash -c "${SETUP_SCRIPT}; sudo ${APT_INSTALL} clangd-\$${CCWS_LLVM_VERSION} jq"
