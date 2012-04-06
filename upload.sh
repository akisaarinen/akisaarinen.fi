#!/bin/sh
WEB=web
DATE=`date +"%Y-%m-%d-%H%M%S"`
SITE="www/_site"
echo "Uploading assets..."
scp -r $SITE/assets kapsi.fi:$WEB/assets.new
echo "Taking assets into use..."
ssh kapsi.fi "cp -r $WEB/assets $WEB/assets-$DATE && mv $WEB/assets.new $WEB/assets"
echo "Uploading new markup"
scp $SITE/*.html kapsi.fi:$WEB/
