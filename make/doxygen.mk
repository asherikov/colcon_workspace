DOXYGEN_SETUP_SCRIPT=source ${WORKSPACE_DIR}/profiles/doxygen/setup.bash

doxclean:
	bash -c "${DOXYGEN_SETUP_SCRIPT} \
		&& rm -Rf \$${CCWS_DOXYGEN_OUTPUT_DIR}/doxygen \
		&& rm -Rf \$${CCWS_DOXYGEN_WORKING_DIR}"

doxall: doxclean
	bash -c "${DOXYGEN_SETUP_SCRIPT} \
        && colcon list \$${COLCON_LIST_ARGS} | xargs -I {} bash -c '${MAKE} dox PKG={}' || true \
		&& colcon graph --base-paths src/ --dot | sed 's@  \"\\(.*\\)\";@  "\\1" [URL=\"./\\1/index.html\"];@' | dot -Tsvg > \$${CCWS_DOXYGEN_OUTPUT_DIR}/graph.svg \
        && cd \$${CCWS_DOXYGEN_OUTPUT_DIR} \
        && cat \$${CCWS_DOXYGEN_CONFIG_DIR}/index_header.html > \$${CCWS_DOXYGEN_OUTPUT_DIR}/index.html \
		&& find ./ -mindepth 2 -name 'index.html' | sed -e 's|\(.*\)|<li><a href=\"\1\">\1</a></li>|' >> index.html \
        && cat \$${CCWS_DOXYGEN_CONFIG_DIR}/index_footer.html >> \$${CCWS_DOXYGEN_OUTPUT_DIR}/index.html"

# documentation for dependencies should be generated first for cross linking
dox: assert_PKG_arg_must_be_specified
	# generate Doxyfile
	bash -c "${DOXYGEN_SETUP_SCRIPT} \
        && rm -Rf \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG} \
        && mkdir -p \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG} \
        && cp \$${CCWS_DOXYGEN_CONFIG_DIR}/Doxyfile \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/Doxyfile \
        && sed -i -e 's/@@PKG@@/${PKG}/' \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/Doxyfile \
        && colcon list \$${COLCON_LIST_ARGS} --packages-up-to ${PKG} --packages-skip ${PKG} \
            | xargs -I {} find \$${CCWS_DOXYGEN_WORKING_DIR} -type d -mindepth 2 -maxdepth 2 -iname '{}' >> \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/deps \
        && cat \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/deps | xargs -I {} cat {} >> \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/Doxyfile \
        && mkdir -p \$${CCWS_DOXYGEN_OUTPUT_DIR} \
        && cd `colcon list --base-paths src/ | grep ${PKG} | sed 's/.*\t\(.*\)\t.*/\1/'` \
        && echo 'TAGFILES+=\"\$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/tags.xml=../${PKG}/\"' > \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/Doxyfile.append \
        && find ~+ -path '*include/*' -type d | sed -e 's/\(.*\)/INCLUDE_PATH+=\"\1\"/' >> \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/Doxyfile.append \
        && doxygen \$${CCWS_DOXYGEN_WORKING_DIR}/${PKG}/Doxyfile"

