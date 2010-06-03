#/bin/sh

# packaging-dmg.sh
# Readown
#
# Created by Sumin Byeon on 6/3/10.
# Copyright 2010 Sumin Byeon. All rights reserved.

VERSION=$(defaults read "${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.app/Contents/Info" CFBundleVersion)
VERSION2=`echo "${VERSION}" | sed "s/\\./_/g" | sed "s/\\ /-/g"`
VOLNAME="Readown ${VERSION}"
DMGNAME="${PROJECT_NAME}-${VERSION}"
SPARSEPATH="${BUILT_PRODUCTS_DIR}/${DMGNAME}.sparseimage"
DMGPATH="${BUILT_PRODUCTS_DIR}/${DMGNAME}.dmg"

hdiutil create -fs HFS+ -ov -type SPARSE -volname "${VOLNAME}" -fsargs "-c c=64,a=16,e=16" "${SPARSEPATH}"
hdiutil attach "${SPARSEPATH}"

ditto "${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.app" "/Volumes/${VOLNAME}/${PROJECT_NAME}.app"
#ditto "${PROJECT_DIR}/Resources/documentation/Licence.rtf" "/Volumes/${VOLNAME}/Licence.rtf"
#ditto "${PROJECT_DIR}/Resources/documentation/Licence_CeCILL_V2-fr.txt" "/Volumes/${VOLNAME}/#Licence_CeCILL_V2-fr.txt"
#ditto "${PROJECT_DIR}/Resources/documentation/Licence_CeCILL_V2-en.txt" "/Volumes/${VOLNAME}/#Licence_CeCILL_V2-en.txt"
#ditto "${PROJECT_DIR}/Resources/documentation/OgreKit-License.txt" "/Volumes/${VOLNAME}/OgreKit-#License.txt"
#ditto "${PROJECT_DIR}/Resources/documentation/Lisez-moi.rtfd" "/Volumes/${VOLNAME}/Lisez-moi.rtfd"
#ditto "${PROJECT_DIR}/Resources/documentation/Read Me.rtfd" "/Volumes/${VOLNAME}/Read Me.rtfd"
#ditto "${PROJECT_DIR}/Resources/documentation/Lies mich.rtfd" "/Volumes/${VOLNAME}/Lies mich.rtfd"
#ditto "${PROJECT_DIR}/Resources/documentation/Léeme.rtfd" "/Volumes/${VOLNAME}/Léeme.rtfd"

hdiutil detach "/Volumes/${VOLNAME}"
hdiutil compact "${SPARSEPATH}"
SECTORS=`hdiutil resize "${SPARSEPATH}" | cut -f 1`
hdiutil resize -sectors "${SECTORS}" "${SPARSEPATH}"
hdiutil convert -imagekey zlib-level=9 -format UDZO -ov "${SPARSEPATH}" -o "${DMGPATH}"
rm -rf "${SPARSEPATH}"
