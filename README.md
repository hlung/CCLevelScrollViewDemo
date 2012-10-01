============
CCLevelScrollViewDemo
============

Created by Thongchai Kolyutsakul on 3/12/12.

Grid Aligned level select screen. Each grid has 3 stars indicator and score label. Arrows to move between pages.
![LevelSelect Stage2](https://github.com/hlung/CCLevelScrollViewDemo/raw/master/screenshots/levelselect_ss2.png)

This is a Modified version of CCScrollLayer of Giv Parvaneh, Stepan Generalov. My work is implemented on top of theirs.
Please note CCScrollLayer (the original work) is now a part of cocos2d-iphone-extensions repo:
https://github.com/cocos2d/cocos2d-iphone-extensions/


Requirements
----
Cocos2D v2.0.0-rc0
iOS 4.3 or later


Important Changes
----
- added arrow for page navigation
- re-implement page dot (because of gl error)
- dampen scrolling of edge pages
- use easeSineOut in page moving for smoother scrolling
- added CCScrollLayerDelegate to track page changes
- added level tiles


How to use
----
Copy CCLevelScrollView folder into your project and push/replace scene to [LevelSelect scene].
e.g. [director_ pushScene: [LevelSelect scene]]; 

change methods inside LevelSelect to customize.

Enjoy! :)