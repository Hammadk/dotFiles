if [ -f ~/.bashrc ]; then
  source ~/.bashrc
else
  echo "Could not find ~/.bashrc"
fi
if [[ -f /opt/dev/dev.sh ]]; then source /opt/dev/dev.sh; fi
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
