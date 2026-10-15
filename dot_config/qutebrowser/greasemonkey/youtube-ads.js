// ==UserScript==
// @name Skip YouTube ads
// @description Skips the ads in YouTube videos
// @run-at document-start
// @include *.youtube.com/*
// ==/UserScript==

document.addEventListener('load', () => {

  const ad = [...document.querySelectorAll('.ad-showing')][0];
  if (ad) {
      const video = document.querySelector('video');
      if (video && video.duration) {
        video.currentTime = video.duration;
        setTimeout(() => {
            const skipBtn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button,.ytp-ad-skip-button-modern');
            if (skipBtn) {
                skipBtn.click();
            }
        }, 50);
    }
  }

  document.querySelectorAll('.style-scope.ytd-action-companion-ad-renderer')
        	.forEach(e => { e.style.display = 'none' });

  const playerAds = document.querySelector('#player-ads');
  if(playerAds != undefined && playerAds.style.display != 'none') {
    playerAds.style.display = 'none';
  }

  const mastheadAd = document.querySelector('#masthead-ad > .style-scope.ytd-rich-grid-renderer');
  if(mastheadAd != undefined && mastheadAd.style.display != 'none') {
    mastheadAd.style.display = 'none';
  }

}, true);
