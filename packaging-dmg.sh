#/bin/sh

# packaging-dmg.sh
# Readown
#
# Created by Sumin Byeon on 6/3/10.

VERSION=$(defaults read "${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.app/Contents/Info" CFBundleVersion)
VERSION2=`echo "${VERSION}" | sed "s/\\./_/g" | sed "s/\\ /-/g"`
VOLNAME="Readown ${VERSION}"
DMGNAME="${PROJECT_NAME}-${VERSION}"
SPARSEPATH="${BUILT_PRODUCTS_DIR}/${DMGNAME}.sparseimage"
DMGPATH="${BUILT_PRODUCTS_DIR}/${DMGNAME}.dmg"

hdiutil create -fs HFS+ -ov -type SPARSE -volname "${VOLNAME}" -fsargs "-c c=64,a=16,e=16" "${SPARSEPATH}"
hdiutil attach "${SPARSEPATH}"

ditto "${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.app" "/Volumes/${VOLNAME}/${PROJECT_NAME}.app"
ditto "${PROJECT_DIR}/LICENSE.markdown" "/Volumes/${VOLNAME}/License.markdown"
ditto "${PROJECT_DIR}/README.markdown" "/Volumes/${VOLNAME}/Readme.markdown"

hdiutil detach "/Volumes/${VOLNAME}"
hdiutil compact "${SPARSEPATH}"
SECTORS=`hdiutil resize "${SPARSEPATH}" | cut -f 1`
hdiutil resize -sectors "${SECTORS}" "${SPARSEPATH}"
hdiutil convert -imagekey zlib-level=9 -format UDZO -ov "${SPARSEPATH}" -o "${DMGPATH}"
rm -rf "${SPARSEPATH}"
