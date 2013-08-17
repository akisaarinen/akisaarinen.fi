#!/bin/sh

set -e
set -u

DIR=$(dirname $0)
WEB=web
DATE=`date +"%Y-%m-%d-%H%M%S"`
SITE="$DIR/www/_site"

echo "Removing old site"
rm -rf $SITE

echo "Compiling site"
pushd $DIR
$DIR/compass.sh compile
$DIR/jekyll.sh build
popd

echo "Uploading assets..."
#ssh kapsi.fi "rm -rf $WEB/assets.new"
#scp -r $SITE/assets kapsi.fi:$WEB/assets.new

echo "Taking assets into use..."
#ssh kapsi.fi "mv $WEB/assets $WEB/assets-$DATE && mv $WEB/assets.new $WEB/assets"

echo "Uploading new markup"
#scp -r $SITE/*.html $SITE/*.xml $SITE/blog/ $SITE/projects/ $SITE/blog-archive/ kapsi.fi:$WEB/

echo "Deploy finished"
