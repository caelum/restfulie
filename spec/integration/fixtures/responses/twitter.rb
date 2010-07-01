module Responses

  module Twitter

    def self.public_timeline
      return <<-ENDRESP
HTTP/1.1 200 OK
Date: Mon, 21 Jun 2010 01:25:16 GMT
Server: hi
Status: 200 OK
X-Transaction: 1277083516-85823-26819
X-RateLimit-Limit: 150
ETag: "ce834dc1485bf89cc4f62da6f1e10cb5"
Last-Modified: Mon, 21 Jun 2010 01:25:16 GMT
X-RateLimit-Remaining: 146
X-Runtime: 0.05201
Content-Type: application/xml; charset=utf-8
Content-Length: 41784
Pragma: no-cache
X-RateLimit-Class: api
X-Revision: DEV
Expires: Tue, 31 Mar 1981 05:00:00 GMT
Cache-Control: no-cache, no-store, must-revalidate, pre-check=0, post-check=0
X-RateLimit-Reset: 1277087009
Set-Cookie: k=68.204.46.87.1277083516203443; path=/; expires=Mon, 28-Jun-10 01:25:16 GMT; domain=.twitter.com
Set-Cookie: guest_id=127708351620755897; path=/; expires=Wed, 21 Jul 2010 01:25:16 GMT
Set-Cookie: _twitter_sess=BAh7CToPY3JlYXRlZF9hdGwrCC%252F9G1gpAToRdHJhbnNfcHJvbXB0MDoHaWQi%250AJTMwM2JhMzcyMmQ5YmE3NDlkNzExMTUyZGZmZmQ0NTg2IgpmbGFzaElDOidB%250AY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA--91fcdba06269406241c81143671ab4c776dc505c; domain=.twitter.com; path=/
Vary: Accept-Encoding
Connection: close

<?xml version="1.0" encoding="UTF-8"?>
<statuses type="array">
<status>
<created_at>Mon Jun 21 01:25:15 +0000 2010</created_at>
<id>16658220000</id>
<text>Nonton ts3RT @annisahppsr: @fionnaps nonton apaan mbak?</text>
<source>&lt;a href=&quot;http://ubertwitter.com&quot; rel=&quot;nofollow&quot;&gt;UberTwitter&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>41067177</id>
<name>fionna padmasari</name>
<screen_name>fionnaps</screen_name>
<location>&#220;T: -6.256292,106.942055</location>
<description>ILDISM</description>
<profile_image_url>http://a1.twimg.com/profile_images/709020780/iu_3924_20663_1227123874644_1125474332_30576007_2332462_n_1__normal.jpg</profile_image_url>
<url>http://www.facebook.com/home.php?#!/profile.php?ref=profile&amp;id=1125474332</url>
<protected>false</protected>
<followers_count>80</followers_count>
<profile_background_color>ff0a80</profile_background_color>
<profile_text_color>0ad6fa</profile_text_color>
<profile_link_color>8605ff</profile_link_color>
<profile_sidebar_fill_color>070708</profile_sidebar_fill_color>
<profile_sidebar_border_color>05fa15</profile_sidebar_border_color>
<friends_count>41</friends_count>
<created_at>Tue May 19 06:13:49 +0000 2009</created_at>
<favourites_count>1</favourites_count>
<utc_offset>-28800</utc_offset>
<time_zone>Pacific Time (US &amp; Canada)</time_zone>
<profile_background_image_url>http://a1.twimg.com/profile_background_images/105938666/pitbull.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>414</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:25:14 +0000 2010</created_at>
<id>16658219000</id>
<text>ok im not watching #trueblood so I am gonna just watch the tweet with my name in them... spoilers are gonna get me!</text>
<source>web</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>131745554</id>
<name>Jenn</name>
<screen_name>JustHadTo</screen_name>
<location>The Emerald Coast, FL</location>
<description></description>
<profile_image_url>http://a3.twimg.com/profile_images/984825527/talitubbie_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>56</followers_count>
<profile_background_color>EDECE9</profile_background_color>
<profile_text_color>634047</profile_text_color>
<profile_link_color>088253</profile_link_color>
<profile_sidebar_fill_color>E3E2DE</profile_sidebar_fill_color>
<profile_sidebar_border_color>D3D2CF</profile_sidebar_border_color>
<friends_count>67</friends_count>
<created_at>Sun Apr 11 05:50:05 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset></utc_offset>
<time_zone></time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276896641/images/themes/theme3/bg.gif</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>809</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:25:11 +0000 2010</created_at>
<id>16658216000</id>
<text>Forte de atitudes e semtimentos.</text>
<source>web</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>116783960</id>
<name>Mariana</name>
<screen_name>webermari</screen_name>
<location></location>
<description></description>
<profile_image_url>http://a3.twimg.com/profile_images/981895359/C_pia_de_S1010038_normal.JPG</profile_image_url>
<url>http://http://www.orkut.com.br/Main#Profile?uid=4814812491622073847&amp;rl=t</url>
<protected>false</protected>
<followers_count>66</followers_count>
<profile_background_color>C0DEED</profile_background_color>
<profile_text_color>e03eb5</profile_text_color>
<profile_link_color>0e0b1a</profile_link_color>
<profile_sidebar_fill_color>dca7e8</profile_sidebar_fill_color>
<profile_sidebar_border_color>db95cb</profile_sidebar_border_color>
<friends_count>209</friends_count>
<created_at>Tue Feb 23 15:23:17 +0000 2010</created_at>
<favourites_count>3</favourites_count>
<utc_offset>-14400</utc_offset>
<time_zone>Santiago</time_zone>
<profile_background_image_url>http://a1.twimg.com/profile_background_images/94480122/capa8.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>2274</statuses_count>
<lang>es</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:25:06 +0000 2010</created_at>
<id>16658211000</id>
<text>&#12362;&#12399;&#12424;&#12540;&#12290;&#12371;&#12428;&#12363;&#12425;&#24066;&#27665;&#30149;&#38498;&#12356;&#12387;&#12390;&#12365;&#12414;&#12540;</text>
<source>&lt;a href=&quot;http://twtr.jp&quot; rel=&quot;nofollow&quot;&gt;Keitai Web&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>30213977</id>
<name>&#12415;&#12435;&#12415;&#12435;</name>
<screen_name>hiromin1412</screen_name>
<location>&#38745;&#23713;&#30476;&#20234;&#26481;&#24066;</location>
<description></description>
<profile_image_url>http://a3.twimg.com/profile_images/882097897/1316642405_49_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>3</followers_count>
<profile_background_color>0099B9</profile_background_color>
<profile_text_color>3C3940</profile_text_color>
<profile_link_color>0099B9</profile_link_color>
<profile_sidebar_fill_color>95E8EC</profile_sidebar_fill_color>
<profile_sidebar_border_color>5ED4DC</profile_sidebar_border_color>
<friends_count>3</friends_count>
<created_at>Fri Apr 10 13:21:57 +0000 2009</created_at>
<favourites_count>0</favourites_count>
<utc_offset>-36000</utc_offset>
<time_zone>Hawaii</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276197224/images/themes/theme4/bg.gif</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>24</statuses_count>
<lang>ja</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:25:00 +0000 2010</created_at>
<id>16658205000</id>
<text>Lu khianatin gw nab (?) RT @Nabilahe: @ziareginae menghianatiku huhuhu</text>
<source>&lt;a href=&quot;http://ubertwitter.com&quot; rel=&quot;nofollow&quot;&gt;UberTwitter&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>94275877</id>
<name>Gisgiskaa</name>
<screen_name>gisgiskaa</screen_name>
<location>&#220;T: -6.274543,106.83991</location>
<description>I really like Gabriel Stevent Damanik,Mario Stevano Aditya Halling,Rangga Raditya. And i am a Gabriel.FC , RISE , Ranggadit :)</description>
<profile_image_url>http://a3.twimg.com/profile_images/1009230929/123493297_normal.jpg</profile_image_url>
<url>http://null</url>
<protected>false</protected>
<followers_count>557</followers_count>
<profile_background_color>000000</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>7DA1B9</profile_sidebar_fill_color>
<profile_sidebar_border_color>000000</profile_sidebar_border_color>
<friends_count>274</friends_count>
<created_at>Thu Dec 03 07:03:44 +0000 2009</created_at>
<favourites_count>4</favourites_count>
<utc_offset>-28800</utc_offset>
<time_zone>Pacific Time (US &amp; Canada)</time_zone>
<profile_background_image_url>http://a3.twimg.com/profile_background_images/70468251/18580_1255310634379_1577984499_638806_5706558_n.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>15197</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:59 +0000 2010</created_at>
<id>16658204000</id>
<text>Dah lumayan nih, baru dpt 80%,, smg bs 100%,, aminnn..</text>
<source>&lt;a href=&quot;http://www.tweets60.com&quot; rel=&quot;nofollow&quot;&gt;Tweets60&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>141885066</id>
<name>Ramadhan Sururi Noer</name>
<screen_name>Soeroeri</screen_name>
<location>Jakarta</location>
<description>Bersahaja.</description>
<profile_image_url>http://a3.twimg.com/profile_images/885683911/ME_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>31</followers_count>
<profile_background_color>9ae4e8</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>
<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>
<friends_count>51</friends_count>
<created_at>Sun May 09 09:13:46 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset></utc_offset>
<time_zone></time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276654401/images/themes/theme1/bg.png</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>245</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:55 +0000 2010</created_at>
<id>16658200000</id>
<text>eu j&#225; acho que no pr&#243;ximo jogo todo mundo vem aqui em casa HSAUHSUAH, vamo deixar a minha m&#227;e doida? HSAHSUH, parei</text>
<source>web</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>62184241</id>
<name>carool</name>
<screen_name>Caroolseluque</screen_name>
<location></location>
<description></description>
<profile_image_url>http://a1.twimg.com/profile_images/900575974/P010310_23.23_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>181</followers_count>
<profile_background_color>642D8B</profile_background_color>
<profile_text_color>3D1957</profile_text_color>
<profile_link_color>f21818</profile_link_color>
<profile_sidebar_fill_color>7AC3EE</profile_sidebar_fill_color>
<profile_sidebar_border_color>65B0DA</profile_sidebar_border_color>
<friends_count>101</friends_count>
<created_at>Sun Aug 02 03:18:16 +0000 2009</created_at>
<favourites_count>6</favourites_count>
<utc_offset>-14400</utc_offset>
<time_zone>Santiago</time_zone>
<profile_background_image_url>http://a1.twimg.com/profile_background_images/106141062/eeeeeu.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>4626</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:53 +0000 2010</created_at>
<id>16658198000</id>
<text>&#21897;&#12364;&#30171;&#12356;&#12398;&#12364;&#12414;&#12384;&#32154;&#12356;&#12390;&#12383;&#12425;&#32819;&#40763;&#31185;&#34892;&#12367;&#12363;&#12394;&#12540;&#12392;&#24605;&#12387;&#12390;&#12383;&#12369;&#12393;&#12289;&#20013;&#36884;&#21322;&#31471;&#12395;&#12510;&#12471;&#12395;&#12394;&#12387;&#12390;&#12427;&#12290;&#12377;&#12387;&#12365;&#12426;&#27835;&#12387;&#12390;&#12427;&#12431;&#12369;&#12391;&#12418;&#12394;&#12356;&#12398;&#12364;&#24494;&#22937;&#12290;&#12393;&#12358;&#12375;&#12383;&#12418;&#12435;&#12363;&#12394;&#12353;&#12290;</text>
<source>&lt;a href=&quot;http://www.misuzilla.org/dist/net/twitterircgateway/&quot; rel=&quot;nofollow&quot;&gt;TwitterIrcGateway&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>14625349</id>
<name>liar</name>
<screen_name>liar_l</screen_name>
<location></location>
<description>&#22909;&#12365;&#12394;&#20986;&#29256;&#31038;&#12399;&#26481;&#20140;&#21109;&#20803;&#31038;&#12289;&#22909;&#12365;&#12394;&#12524;&#12540;&#12505;&#12523;&#12399;&#12495;&#12516;&#12459;&#12527;FT&#12290;</description>
<profile_image_url>http://a3.twimg.com/profile_images/61904907/n_normal.jpg</profile_image_url>
<url>http://d.hatena.ne.jp/ltail/</url>
<protected>false</protected>
<followers_count>88</followers_count>
<profile_background_color>EBEBEB</profile_background_color>
<profile_text_color>333333</profile_text_color>
<profile_link_color>990000</profile_link_color>
<profile_sidebar_fill_color>F3F3F3</profile_sidebar_fill_color>
<profile_sidebar_border_color>DFDFDF</profile_sidebar_border_color>
<friends_count>97</friends_count>
<created_at>Fri May 02 12:57:15 +0000 2008</created_at>
<favourites_count>10</favourites_count>
<utc_offset>32400</utc_offset>
<time_zone>Osaka</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276197224/images/themes/theme7/bg.gif</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>2273</statuses_count>
<lang>ja</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:51 +0000 2010</created_at>
<id>16658196000</id>
<text>&#20170;&#26085;&#12418;&#24179;&#21644;&#12384; http://yfrog.com/5br4mej</text>
<source>&lt;a href=&quot;http://itunes.apple.com/app/twitter/id333903271?mt=8&quot; rel=&quot;nofollow&quot;&gt;Twitter for iPhone&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>146722267</id>
<name>rumi yamazaki</name>
<screen_name>yama_jr</screen_name>
<location>saitama</location>
<description></description>
<profile_image_url>http://a1.twimg.com/profile_images/920410832/2010-04_193_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>4</followers_count>
<profile_background_color>9ae4e8</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>
<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>
<friends_count>7</friends_count>
<created_at>Sat May 22 04:59:13 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset>32400</utc_offset>
<time_zone>Tokyo</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276563079/images/themes/theme1/bg.png</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>75</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:36 +0000 2010</created_at>
<id>16658182000</id>
<text>&quot;Que formosa apar&#234;ncia tem a falsidade.&quot; (William Shakespeare)</text>
<source>web</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>124305808</id>
<name>Daniel Soares</name>
<screen_name>deniel_havok</screen_name>
<location>Brazil</location>
<description>Take it slow
Take it easy on me
Shed some light
Shed some light on things</description>
<profile_image_url>http://a3.twimg.com/profile_images/761030279/14-03-10_0150_normal.jpg</profile_image_url>
<url>http://www.formspring.me/DenielHavok</url>
<protected>false</protected>
<followers_count>218</followers_count>
<profile_background_color>1c191a</profile_background_color>
<profile_text_color>666666</profile_text_color>
<profile_link_color>2FC2EF</profile_link_color>
<profile_sidebar_fill_color>252429</profile_sidebar_fill_color>
<profile_sidebar_border_color>181A1E</profile_sidebar_border_color>
<friends_count>450</friends_count>
<created_at>Thu Mar 18 23:50:21 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset>-10800</utc_offset>
<time_zone>Brasilia</time_zone>
<profile_background_image_url>http://a3.twimg.com/profile_background_images/104730329/desenhos-animados-faculdade-5.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>972</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:33 +0000 2010</created_at>
<id>16658179000</id>
<text>&#12383;&#12371;&#12395;&#12419;&#12435;&#12289;&#30446;&#12364;&#12365;&#12425;&#12365;&#12425;&#12420;&#12290;</text>
<source>&lt;a href=&quot;http://movatwitter.jp/&quot; rel=&quot;nofollow&quot;&gt;movatwitter&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>114217112</id>
<name>&#20013;&#26449;&#12288;&#32681;&#23558;</name>
<screen_name>kurkurkurpar</screen_name>
<location>&#24220;&#20013;</location>
<description>&#26032;&#31038;&#20250;&#20154;&#65297;&#24180;&#30446;&#12290;
&#12364;&#12416;&#12375;&#12419;&#12425;&#12395;&#38929;&#24373;&#12387;&#12390;&#12362;&#12426;&#12414;&#12377;&#65281;
&#36259;&#21619;&#12399;&#27598;&#22238;&#26032;&#12375;&#12356;&#12371;&#12392;&#12434;&#22987;&#12417;&#12427;&#12371;&#12392;&#12290;&#35201;&#12377;&#12427;&#12395;&#12354;&#12435;&#12414;&#12426;&#38263;&#32154;&#12365;&#12375;&#12414;&#12379;&#12435;&#12290;
&#20170;&#12399;&#12480;&#12452;&#12456;&#12483;&#12488;&#23455;&#34892;&#20013;&#65281;&#24540;&#25588;&#12375;&#12390;&#19979;&#12373;&#12356;&#12290;</description>
<profile_image_url>http://a1.twimg.com/profile_images/696691248/yoshi_normal.jpg</profile_image_url>
<url>http://ameblo.jp/kurpar/</url>
<protected>false</protected>
<followers_count>15</followers_count>
<profile_background_color>642D8B</profile_background_color>
<profile_text_color>3D1957</profile_text_color>
<profile_link_color>FF0000</profile_link_color>
<profile_sidebar_fill_color>7AC3EE</profile_sidebar_fill_color>
<profile_sidebar_border_color>65B0DA</profile_sidebar_border_color>
<friends_count>34</friends_count>
<created_at>Sun Feb 14 15:35:52 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset>32400</utc_offset>
<time_zone>Tokyo</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276654401/images/themes/theme10/bg.gif</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>154</statuses_count>
<lang>ja</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:28 +0000 2010</created_at>
<id>16658174000</id>
<text>Modern apartment, Liding&#246; SEL1: With balcony and nice garden http://bit.ly/adVNLU</text>
<source>&lt;a href=&quot;http://twitterfeed.com&quot; rel=&quot;nofollow&quot;&gt;twitterfeed&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>88232754</id>
<name>Kr&#229;ke Lithander</name>
<screen_name>daysinsweden</screen_name>
<location>Stockholm, Sweden</location>
<description>Founder of Days in Sweden, cookbook writer and food lover</description>
<profile_image_url>http://s.twimg.com/a/1276896641/images/default_profile_1_normal.png</profile_image_url>
<url>http://www.daysinsweden.com</url>
<protected>false</protected>
<followers_count>6</followers_count>
<profile_background_color>B2DFDA</profile_background_color>
<profile_text_color>333333</profile_text_color>
<profile_link_color>93A644</profile_link_color>
<profile_sidebar_fill_color>ffffff</profile_sidebar_fill_color>
<profile_sidebar_border_color>eeeeee</profile_sidebar_border_color>
<friends_count>0</friends_count>
<created_at>Sat Nov 07 17:45:57 +0000 2009</created_at>
<favourites_count>0</favourites_count>
<utc_offset>3600</utc_offset>
<time_zone>Stockholm</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276896641/images/themes/theme13/bg.gif</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>58</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:26 +0000 2010</created_at>
<id>16658172000</id>
<text>RT @dhitals: RT @viansatrio: YANG MAU DI FOLLOW RT !</text>
<source>&lt;a href=&quot;http://m.tuitwit.com&quot; rel=&quot;nofollow&quot;&gt;Tuitwit&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>137223260</id>
<name>Suci Wulan Lestary</name>
<screen_name>suciwl</screen_name>
<location>Jl. Dr Sumarno, JKT 13940, ID</location>
<description>I'm addicted to music. I loves RAN and STORIA and Lenka. Let's be a friend! Click follow to know me! :)</description>
<profile_image_url>http://a1.twimg.com/profile_images/995459430/mypics3792_normal.jpg</profile_image_url>
<url>http://formspring.me/suchii</url>
<protected>false</protected>
<followers_count>202</followers_count>
<profile_background_color>B2DFDA</profile_background_color>
<profile_text_color>333333</profile_text_color>
<profile_link_color>93A644</profile_link_color>
<profile_sidebar_fill_color>ffffff</profile_sidebar_fill_color>
<profile_sidebar_border_color>eeeeee</profile_sidebar_border_color>
<friends_count>118</friends_count>
<created_at>Mon Apr 26 04:46:21 +0000 2010</created_at>
<favourites_count>6</favourites_count>
<utc_offset>-28800</utc_offset>
<time_zone>Pacific Time (US &amp; Canada)</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276896641/images/themes/theme13/bg.gif</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications></notifications>
<geo_enabled>true</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>1535</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:22 +0000 2010</created_at>
<id>16658168000</id>
<text>O Fant&#225;stico agora detonou o Dunga! 'incompatibilidade dos xingamentos do tecnico com o cargo que ele ocupa'...</text>
<source>web</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>59176486</id>
<name>TyciCronembergerVaz</name>
<screen_name>tycianevaz</screen_name>
<location>Teresina - S&#227;o Paulo</location>
<description>Jornalista, mestre em Comunica&#231;&#227;o Social e esposa do Lucas...</description>
<profile_image_url>http://a1.twimg.com/profile_images/850881172/tw_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>293</followers_count>
<profile_background_color>FF6699</profile_background_color>
<profile_text_color>362720</profile_text_color>
<profile_link_color>B40B43</profile_link_color>
<profile_sidebar_fill_color>E5507E</profile_sidebar_fill_color>
<profile_sidebar_border_color>CC3366</profile_sidebar_border_color>
<friends_count>234</friends_count>
<created_at>Wed Jul 22 16:48:14 +0000 2009</created_at>
<favourites_count>1</favourites_count>
<utc_offset>-10800</utc_offset>
<time_zone>Brasilia</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276654401/images/themes/theme11/bg.gif</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>1139</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:20 +0000 2010</created_at>
<id>16658166000</id>
<text>Hey fellow followers If you want MORE followers check out this site: http://is.gd/cBGbG</text>
<source>&lt;a href=&quot;http://apiwiki.twitter.com/&quot; rel=&quot;nofollow&quot;&gt;API&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>90276995</id>
<name>Dave Hastings</name>
<screen_name>babymatrix24</screen_name>
<location></location>
<description></description>
<profile_image_url>http://a1.twimg.com/profile_images/554177094/Untitled_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>23</followers_count>
<profile_background_color>022330</profile_background_color>
<profile_text_color>333333</profile_text_color>
<profile_link_color>0084B4</profile_link_color>
<profile_sidebar_fill_color>C0DFEC</profile_sidebar_fill_color>
<profile_sidebar_border_color>a8c7f7</profile_sidebar_border_color>
<friends_count>66</friends_count>
<created_at>Sun Nov 15 23:49:10 +0000 2009</created_at>
<favourites_count>1</favourites_count>
<utc_offset></utc_offset>
<time_zone></time_zone>
<profile_background_image_url>http://a1.twimg.com/profile_background_images/56428090/1969camaro3.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>302</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:16 +0000 2010</created_at>
<id>16658162000</id>
<text>&#22269;&#31435;&#26997;&#22320;&#30740;&#31350;&#25152;&#12391;&#21335;&#26997;&#12539;&#21271;&#26997;&#31185;&#23398;&#39208;&#12458;&#12540;&#12503;&#12531; &amp; &#19968;&#33324;&#20844;&#38283; - &#20013;&#12398;&#20154;&#12394;&#12398;&#12391; AC &#26352;&#12367;&#12289; &#22269;&#31435;&#26997;&#22320;&#30740;&#31350;&#25152;&#12364; 2010 &#24180; 7 &#26376; 24 &#26085; (&#22303;) &#12398;&#12300;&#21335;&#26997;&#12539;&#21271;&#26997;&#31185;&#23398;&#39208;&#12301;&#12398;&#38283;&#39208;&#12395;&#20341;&#12379;.. &#8594; http://am6.jp/9mZzNd</text>
<source>&lt;a href=&quot;http://feedtweet.am6.jp/&quot; rel=&quot;nofollow&quot;&gt;&#9758; feedtweet.jp &#9756;&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>131736559</id>
<name>Matzubotsree</name>
<screen_name>matzubotsree</screen_name>
<location></location>
<description></description>
<profile_image_url>http://s.twimg.com/a/1276896641/images/default_profile_3_normal.png</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>4</followers_count>
<profile_background_color>9ae4e8</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>
<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>
<friends_count>12</friends_count>
<created_at>Sun Apr 11 05:05:41 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset></utc_offset>
<time_zone></time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276896641/images/themes/theme1/bg.png</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>507</statuses_count>
<lang>ja</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:14 +0000 2010</created_at>
<id>16658160000</id>
<text>Update: Latest Designer Handbag Auctions http://designerfashionhandbag.com/designer-handbags/latest-designer-handbag-auctions-483/</text>
<source>&lt;a href=&quot;http://alexking.org/projects/wordpress&quot; rel=&quot;nofollow&quot;&gt;Twitter Tools&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>18464059</id>
<name>Jennifer Wolf</name>
<screen_name>HandbagInfo</screen_name>
<location>NYC</location>
<description>Your Online Source for Designer Handbags, Designer Purses and Designer Totes</description>
<profile_image_url>http://a1.twimg.com/profile_images/521435946/978-2008_normal.jpg</profile_image_url>
<url>http://purseshandbagstotes.com</url>
<protected>false</protected>
<followers_count>550</followers_count>
<profile_background_color>C0DEED</profile_background_color>
<profile_text_color>333333</profile_text_color>
<profile_link_color>0084B4</profile_link_color>
<profile_sidebar_fill_color>ffedf7</profile_sidebar_fill_color>
<profile_sidebar_border_color>C0DEED</profile_sidebar_border_color>
<friends_count>608</friends_count>
<created_at>Tue Dec 30 00:10:12 +0000 2008</created_at>
<favourites_count>0</favourites_count>
<utc_offset>-18000</utc_offset>
<time_zone>Eastern Time (US &amp; Canada)</time_zone>
<profile_background_image_url>http://a3.twimg.com/profile_background_images/53174897/handbags.jpg</profile_background_image_url>
<profile_background_tile>true</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>5200</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:13 +0000 2010</created_at>
<id>16658159000</id>
<text>Steelcase Creates &amp;quot;Harder Working Spaces&amp;quot; At NeoCon 2010 http://LNK.by/eNPF</text>
<source>&lt;a href=&quot;http://apiwiki.twitter.com/&quot; rel=&quot;nofollow&quot;&gt;API&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>47705961</id>
<name>Howard Gengerke</name>
<screen_name>HowGQ</screen_name>
<location>Denver, Colorado</location>
<description>I am a pilot, real estate investor and I love to have fun!!</description>
<profile_image_url>http://s.twimg.com/a/1276654401/images/default_profile_2_normal.png</profile_image_url>
<url>http://www.networkerlink.com</url>
<protected>false</protected>
<followers_count>545</followers_count>
<profile_background_color>9ae4e8</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>
<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>
<friends_count>456</friends_count>
<created_at>Tue Jun 16 18:46:09 +0000 2009</created_at>
<favourites_count>0</favourites_count>
<utc_offset>-25200</utc_offset>
<time_zone>Mountain Time (US &amp; Canada)</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276654401/images/themes/theme1/bg.png</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>false</following>
<statuses_count>6475</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:11 +0000 2010</created_at>
<id>16658157000</id>
<text>10 games that shaped the Lakers' season - Los Angeles Times http://is.gd/cWZSd</text>
<source>&lt;a href=&quot;http://easytweets.com&quot; rel=&quot;nofollow&quot;&gt;EasyTweets&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>2085081</id>
<name>Phoenix Suns</name>
<screen_name>Suns</screen_name>
<location>phoenix, az</location>
<description>Phoenix Suns, Suns, NBA, Basketball. This is an independent twitter account by fans, for fans. We have no official affiliation at all. </description>
<profile_image_url>http://a1.twimg.com/profile_images/66589274/pho2_normal.jpg</profile_image_url>
<url>http://www.vyous.com/sports/nba/phoenix-suns </url>
<protected>false</protected>
<followers_count>2285</followers_count>
<profile_background_color>929AA0</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>F1F5DF</profile_sidebar_fill_color>
<profile_sidebar_border_color>555555</profile_sidebar_border_color>
<friends_count>0</friends_count>
<created_at>Sat Mar 24 05:53:08 +0000 2007</created_at>
<favourites_count>0</favourites_count>
<utc_offset>-18000</utc_offset>
<time_zone>Eastern Time (US &amp; Canada)</time_zone>
<profile_background_image_url>http://a3.twimg.com/profile_background_images/3516993/phoenixsuns.jpg</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications>false</notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following>true</following>
<statuses_count>6015</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
<status>
<created_at>Mon Jun 21 01:24:10 +0000 2010</created_at>
<id>16658156000</id>
<text>&#50500;~~~~~~~~~~~~~~~~~~&#51060;&#54256; &#49324;&#44256;&#49910;&#45796;~.~ &#45432;&#53412;&#50500;&#54256; &#44277;&#51676;&#54665;&#49324;&#54664;&#51012;&#46412; &#44396;&#51077;&#54664;&#45716;&#45936; &#51221;&#47568; &#54980;&#54924;&#46104;&#50836; &#12372;..&#12372;</text>
<source>&lt;a href=&quot;http://mobileways.de/gravity&quot; rel=&quot;nofollow&quot;&gt;Gravity&lt;/a&gt;</source>
<truncated>false</truncated>
<in_reply_to_status_id></in_reply_to_status_id>
<in_reply_to_user_id></in_reply_to_user_id>
<favorited>false</favorited>
<in_reply_to_screen_name></in_reply_to_screen_name>
<user>
<id>138910836</id>
<name>&#49457;&#52285;&#54788;</name>
<screen_name>kxtcsung</screen_name>
<location>36.7136033,126.5450626</location>
<description>&#54620;&#44397; &#51060;&#44200;&#46972;~!~!~!@#$$%^^&amp;&amp;</description>
<profile_image_url>http://a3.twimg.com/profile_images/995120787/63444935744388750_normal.jpg</profile_image_url>
<url></url>
<protected>false</protected>
<followers_count>171</followers_count>
<profile_background_color>9ae4e8</profile_background_color>
<profile_text_color>000000</profile_text_color>
<profile_link_color>0000ff</profile_link_color>
<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>
<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>
<friends_count>310</friends_count>
<created_at>Sat May 01 00:31:04 +0000 2010</created_at>
<favourites_count>0</favourites_count>
<utc_offset>32400</utc_offset>
<time_zone>Seoul</time_zone>
<profile_background_image_url>http://s.twimg.com/a/1276896641/images/themes/theme1/bg.png</profile_background_image_url>
<profile_background_tile>false</profile_background_tile>
<notifications></notifications>
<geo_enabled>false</geo_enabled>
<verified>false</verified>
<following></following>
<statuses_count>61</statuses_count>
<lang>en</lang>
<contributors_enabled>false</contributors_enabled>
</user>
<geo/>
<coordinates/>
<place/>
<contributors/>
</status>
</statuses>
ENDRESP
    end

  end

end
