============
CCLevelScrollViewDemo
============

Grid Aligned level select screen. Each grid has 3 stars indicator and score label. Arrows to move between pages.

This is a modified version of `CCScrollLayer` of *Giv Parvaneh, Stepan Generalov*. My work is implemented on top of theirs.

Please note `CCScrollLayer` (the original work) is now a part of [cocos2d-iphone-extensions repo](https://github.com/cocos2d/cocos2d-iphone-extensions)

![LevelSelect Stage2](https://github.com/hlung/CCLevelScrollViewDemo/raw/master/screenshots/levelselect_ss2.png)


Requirements
----
Cocos2D v2.0.0-rc0
iOS 4.3 or later


Changelog
----
- added arrow for page navigation
- re-implement page dot (because of some gl error)
- dampen scrolling of edge pages
- use `easeSineOut` in page moving for smoother scrolling
- added `CCScrollLayerDelegate` to track page changes
- added level tiles


How to use
----
1. Copy `CCLevelScrollView` folder into your project and push/replace scene to `[LevelSelect scene]`.
e.g. `[director_ pushScene: [LevelSelect scene]]`; 
1. Change methods inside `LevelSelect` to customize.
1. Enjoy! :)
