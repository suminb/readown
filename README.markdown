Readown
=======

Readown은 [Markdown][1] 형식의 텍스트 파일을 읽기 위한 Mac OS X용 애플리케이션입니다. [홍민희][2]가 Cocoa를 처음 배우면서 제작해봤습니다(아이콘은 [이흥섭][3]이 그렸습니다). 소스 코드와 함께 [LGPL][4]로 배포됩니다. 버그 신고 및 기타 문의 사항은 제 이메일이나 [미투데이][5]로 해주세요. 제 이메일 주소는 [홈페이지][2]에서 찾을 수 있습니다.

![Readown 화면](http://h.imagehost.org/0576/Screen_shot_2010-06-03_at_3_04_28_AM.png)

구하기                                                               {#download}
------

디스크 이미지 파일을 아래 페이지에서 구할 수 있습니다.

>   <http://code.google.com/p/readown/downloads/list>

소스 코드는 Subversion을 통해 구할 수 있습니다.

	svn checkout http://readown.googlecode.com/svn/trunk/ readown-read-only

열 수 있는 확장자
-----------------

Readown은 다음 확장자의 파일들을 열 수 있습니다. 물론 Markdown으로 작성되었다고 가정합니다. 파일을 더블 클릭하거나 Readown에 떨구면 열립니다.

* markdown
* mkdn
* text
* txt

사용 프로그램
-------------

Readown은 내부적으로 아래와 같은 프로그램을 사용합니다.

* [PHP Markdown Extra][6]
* [PHP SmartyPants Typographer][7]

TODO
----

* 사용자 정의 CSS 사용 기능
* 자동 업데이트 기능
* Markdown Extra 및 SmartyPants Typographer 적용 여부를 환경 설정에서 정할 수 있도록
* <kbd>Command</kbd>+<kbd>R</kbd>, <kbd>F5</kbd> 눌렀을 때 새로 고침 기능
* 파일 내용 수정되었을 때 자동으로 새로 고침 (환경설정에 따라)

 *[LGPL]: GNU Lesser General Public License
 *[CSS]: Cascading Style Sheets
  [1]: http://daringfireball.net/projects/markdown/
  [2]: http://dahlia.kr/
  [3]: http://heungsub.net/
  [4]: LICENSE.markdown
  [5]: http://me2day.net/dahlia  "dahlia 님의 미투데이"
  [6]: http://michelf.com/projects/php-markdown/extra/
  [7]: http://michelf.com/projects/php-smartypants/typographer/
