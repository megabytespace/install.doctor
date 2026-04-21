//import { Component, h, Prop, Build } from '@stencil/core'
import { Component, h } from '@stencil/core';
import { Routes } from '../../router';
import state from '../../store';
//import { importResource } from '../../utils/common'
//import { Button } from 'ionic-ds-no-fonts'
//import { defaults } from '../../store'
//declare let window: any
//declare let jQuery: any
//declare let RS_MODULES: any
//declare let revapi2: any
//declare let revslider_showDoubleJqueryError: any
@Component({
  tag: 'capacitor-site',
  styleUrl: 'capacitor-site.scss',
})
export class App {
  /*@Prop() showEmailInput: boolean = false;
  @Prop() showCommunity: boolean = false;
  @Prop() scriptsLoaded: number = 0;
  isTouchscreen = 'ontouchstart' in window ||
    navigator.maxTouchPoints > 0 ||
    (navigator as any).msMaxTouchPoints > 0 ||
    window.innerWidth < 1024
  @Prop() fullScreenSliderHTML = `
  <rs-module-wrap id="ai-id-slider_wrapper" data-alias="ai-particles-id" data-source="gallery"
  style="visibility:hidden;background:transparent;padding:0;">
  <rs-module id="ai-id-slider" class="rs-respect-topbar" style="" data-version="6.6.20">
      <rs-slides style="overflow: hidden; position: absolute;">
          <rs-slide style="position: absolute;" data-key="rs-4" data-title="Slide" data-sba="f:true;b:true;"
              data-anim="adpr:false;" data-in="o:0;col:400;" data-out="a:false;" id="ai-particles">
              <img src="/assets/img/transparent.png" alt="Slide" title="..." class="rev-slidebg tp-rs-img"
                  data-bg="c:linear-gradient(130deg, rgba(29,130,183,1) 0%, rgba(5,61,122,1) 30%, rgba(12,28,59,1) 65%, rgba(1,10,38,1) 100%);"
                  data-parallax="1" data-no-retina />
              <rs-group id="slider-2-slide-4-layer-0" data-type="group" data-rsp_ch="on" data-xy="x:c;y:m;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;a:center;" data-dim="w:85%,85%,85%,100%;"
                  data-frame_0="o:1;" data-frame_999="o:0;st:w;sR:8700;sA:9000;" style="z-index:12;"><rs-layer
                      id="slider-2-slide-4-layer-18" class="rs-pxl-4" data-type="shape" data-rsp_ch="on"
                      data-xy="x:c;yo:190px,156px,118px,72px;" data-pos="a"
                      data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                      data-dim="w:417px,344px,261px,161px;h:10px,8px,6px,3px;" data-clip="u:true;"
                      data-frame_0="x:0%;o:1;cp:0%;" data-frame_1="e:power4.inOut;st:300;sp:1000;sR:300;"
                      data-frame_999="o:0;st:w;sR:7700;"
                      style="z-index:9;background:linear-gradient(90deg, rgba(17,158,255,1) 0%, rgba(178,190,205,1) 100%);">
                  </rs-layer><rs-layer id="slider-2-slide-4-layer-5" class="rs-pxl-3" data-type="text"
                      data-rsp_ch="on" data-xy="y:m;" data-pos="r"
                      data-text="w:normal;s:100,82,62,38;f:left,none,none,none;c:both,none,none,none;l:100,82,62,38;fw:700;a:center;"
                      data-flcr="f:left,none,none,none;c:both,none,none,none;" data-dim="w:100%;"
                      data-frame_0="o:1;" data-frame_0_lines="d:5;x:cyc(-20|20);o:0;"
                      data-frame_1="e:power4.out;sp:1000;" data-frame_1_lines="d:10;"
                      data-frame_999="o:0;st:w;sR:7700;" style="z-index:8;font-family:'Inter';">The Age
                      Of<br />
                      Artificial<br />
                      Intelligence
                  </rs-layer><rs-layer id="slider-2-slide-4-layer-1" class="add-buttons" data-type="text"
                      data-color="rgba(255, 255, 255, 0.81)||rgba(255, 255, 255, 0.81)||rgba(255, 255, 255, 0.81)||rgba(255, 255, 255, 0.69)"
                      data-tsh="c:rgba(255,255,255,0.25);h:1px,0px,0px,0px;v:1px,0px,0px,0px;b:1px,0px,0px,0px;"
                      data-rsp_ch="on" data-xy="y:m;" data-pos="r"
                      data-text="w:normal;s:25,20,15,20;l:35,28,21,25;a:center;" data-corners="rs-fcr;rs-bcr;"
                      data-disp="inline-block" data-margin="t:24,20,15,20;b:24,20,15,30;"
                      data-padding="r:0,0,0,30;l:0,0,0,30;" data-frame_1="st:500;sp:1000;sR:500;"
                      data-frame_999="o:0;st:w;sR:7500;"
                      style="z-index:7;font-family:'Inter';display:inline-block;">Immerse yourself in an
                      AI-powered desktop experience. Join our community, integrating top open-source software
                      across all operating systems. Explore GitHub's best tools and collaborate with AI
                      innovators. Let's redefine the digital realm with unparalleled efficiency and
                      creativity.<br />

                  </rs-layer><!--<rs-layer id="slider-2-slide-4-layer-25" class="rev-btn replace-with-buttons" data-type="button"
                      data-color="rgba(3, 6, 11, 0.81)"
                      data-bsh="c:rgba(255,255,255,0.14);h:1px,0px,0px,0px;v:1px,0px,0px,0px;b:1px,0px,0px,0px;s:1px,0px,0px,0px;"
                      data-rsp_ch="on" data-xy="x:c;y:m;yo:0,0,0,-50px;" data-pos="r"
                      data-text="w:normal;s:24,19,14,15;l:69,56,42,40;ls:4px,3px,2px,1px;fw:700;a:center;"
                      data-dim="minh:0px,none,none,none;"
                      data-actions='o:click;a:scrollbelow;sp:1000ms;e:power1.inOut;' data-disp="inline-block"
                      data-padding="r:24,20,15,20;l:24,20,15,20;" data-border="bor:50px,50px,50px,50px;"
                      data-clip="u:true;" data-frame_0="x:0%;o:1;cp:0%;"
                      data-frame_1="e:power4.out;st:1500;sp:1000;" data-frame_999="o:0;st:w;sR:6500;"
                      data-frame_hover="c:#03060b;bgc:linear-gradient(90deg, rgba(233,237,243,1) 0%, rgba(17,158,255,1) 100%);bor:50px,50px,50px,50px;e:power1.inOut;"
                      style="z-index:6;background:linear-gradient(90deg, rgba(17,158,255,1) 0%, rgba(233,237,243,1) 100%);font-family:'Inter';text-transform:uppercase;display:inline-block;"><i
                          class="fa-play" style="margin-right: 8px; margin-left: 8px;"></i> Start Now
                  </rs-layer>--></rs-group><rs-layer id="slider-2-slide-4-layer-2"
                  class="tp-shape tp-shapewrapper tp-thecluster" data-type="shape" data-rsp_ch="on"
                  data-xy="x:r,r,r,c;xo:-200px,-165px,-125px,0;y:m;yo:0,0,0,-190px;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                  data-dim="w:1000px,825px,626px,500px;h:1000px,825px,626px,500px;" data-frame_0="sX:0;sY:0;"
                  data-frame_1="e:power4.out;sp:1500;" data-frame_999="o:0;st:w;sR:7500;"
                  data-clusterdata='ms:10%;mi:12;mp:24;ma:2000;sf:random3D;mc:direction;mn:1;mf:109;mm:1;mm2:1;mm3:1;g1X:-20;g2X:0;g3X:20;gl:1;gv:11;t1:1;t2:;t3:1;sIX:0;sIY:0;sVX:0;sVY:4;pc:radial-gradient(ellipse at center, rgba(5,61,122,1) 0%, rgba(5,61,122,1) 50%, rgba(29,130,183,1) 75%, rgba(255,124,143,1) 90%, rgba(224,170,97,1) 100%);cim:1%;as:loop;aniY:6;mps:lifetime;ld:20;mg:1;msp:;msv:6;ifm:indivRota;ifr:100;'
                  style="z-index:11;background-color:rgba(0,0,0,0.0);">
              </rs-layer><rs-layer id="slider-2-slide-4-layer-3" class="rs-pxl-1" data-type="shape"
                  data-rsp_ch="on"
                  data-xy="x:r;xo:-850px,-701px,-532px,-328px;y:m;yo:-50px,-41px,-31px,-19px;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                  data-dim="w:1500px,1238px,940px,579px;h:1500px,1238px,940px,579px;" data-basealign="slide"
                  data-frame_0="x:100px,82px,62px,38px;" data-frame_1="sp:1000;"
                  data-frame_999="o:0;st:w;sR:8000;"
                  style="z-index:9;background:radial-gradient(ellipse at center, rgba(17,158,255,1) 0%, rgba(19,158,254,0.99) 4.67%, rgba(24,158,249,0.96) 9.34%, rgba(35,159,241,0.9) 14.01%, rgba(48,160,232,0.83) 18.68%, rgba(62,161,221,0.75) 23.35%, rgba(80,162,207,0.65) 28.02%, rgba(98,163,193,0.55) 32.69%, rgba(117,164,179,0.45) 37.36%, rgba(135,165,165,0.35) 42.03%, rgba(153,166,152,0.25) 46.70%, rgba(167,167,140,0.17) 51.37%, rgba(180,168,131,0.1) 56.04%, rgba(191,169,123,0.04) 60.71%, rgba(196,169,118,0.01) 65.38%, rgba(198,169,117,0) 70%, rgba(198,169,117,0) 70.67%, rgba(199,169,116,0) 71.34%, rgba(201,169,115,0) 72.01%, rgba(202,169,114,0) 72.68%, rgba(205,169,112,0) 73.35%, rgba(207,169,110,0) 74.02%, rgba(210,169,108,0) 74.69%, rgba(212,170,106,0) 75.36%, rgba(215,170,104,0) 76.03%, rgba(218,170,102,0) 76.70%, rgba(220,170,100,0) 77.37%, rgba(221,170,99,0) 78.04%, rgba(223,170,98,0) 78.71%, rgba(224,170,97,0) 79.38%, rgba(224,170,97,0) 80%);">
              </rs-layer><rs-layer id="slider-2-slide-4-layer-4" class="rs-pxl-2" data-type="shape"
                  data-rsp_ch="on" data-xy="x:c;y:m;yo:500px,412px,313px,193px;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                  data-dim="w:1200px,990px,752px,463px;h:1200px,990px,752px,463px;"
                  data-frame_0="y:100px,82px,62px,38px;" data-frame_1="sp:1000;"
                  data-frame_999="o:0;st:w;sR:8000;"
                  style="z-index:8;background:radial-gradient(ellipse at center, rgba(17,158,255,1) 0%, rgba(19,158,254,0.99) 4.67%, rgba(26,157,251,0.96) 9.34%, rgba(39,155,245,0.9) 14.01%, rgba(55,153,237,0.83) 18.68%, rgba(73,150,229,0.75) 23.35%, rgba(95,147,218,0.65) 28.02%, rgba(117,144,208,0.55) 32.69%, rgba(139,140,197,0.45) 37.36%, rgba(161,137,187,0.35) 42.03%, rgba(184,134,176,0.25) 46.70%, rgba(201,131,168,0.17) 51.37%, rgba(217,129,161,0.1) 56.04%, rgba(230,127,154,0.04) 60.71%, rgba(237,126,151,0.01) 65.38%, rgba(239,126,150,0) 70%, rgba(239,126,150,0) 70.33%, rgba(240,126,150,0) 70.66%, rgba(241,126,149,0) 70.99%, rgba(242,126,149,0) 71.32%, rgba(243,126,148,0) 71.65%, rgba(245,125,148,0) 71.98%, rgba(246,125,147,0) 72.31%, rgba(248,125,146,0) 72.64%, rgba(249,125,145,0) 72.97%, rgba(251,125,145,0) 73.30%, rgba(252,124,144,0) 73.63%, rgba(253,124,144,0) 73.96%, rgba(254,124,143,0) 74.29%, rgba(255,124,143,0) 74.62%, rgba(255,124,143,0) 75%);">
              </rs-layer><rs-layer id="slider-2-slide-4-layer-16" data-type="shape" data-rsp_ch="on"
                  data-xy="x:c;xo:-1px,0,0,0;y:m;yo:-1px,0,0,0;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;" data-dim="w:100%;h:100%;"
                  data-basealign="slide" data-frame_1="sp:1000;" data-frame_999="o:0;st:w;sR:8000;"
                  style="z-index:10;background:linear-gradient(330deg, rgba(17,158,255,1) 0%, rgba(17,158,255,0.99) 3.33%, rgba(17,158,255,0.96) 6.66%, rgba(17,158,255,0.9) 9.99%, rgba(17,158,255,0.83) 13.32%, rgba(17,158,255,0.75) 16.65%, rgba(17,158,255,0.65) 19.98%, rgba(17,158,255,0.55) 23.31%, rgba(17,158,255,0.45) 26.64%, rgba(17,158,255,0.35) 29.97%, rgba(17,158,255,0.25) 33.30%, rgba(17,158,255,0.17) 36.63%, rgba(17,158,255,0.1) 39.96%, rgba(17,158,255,0.04) 43.29%, rgba(17,158,255,0.01) 46.62%, rgba(17,158,255,0) 50%, rgba(17,158,255,0) 50.33%, rgba(17,158,255,0) 50.66%, rgba(17,158,255,0) 50.99%, rgba(17,158,255,0) 51.32%, rgba(17,158,255,0) 51.65%, rgba(17,158,255,0) 51.98%, rgba(17,158,255,0) 52.31%, rgba(17,158,255,0) 52.64%, rgba(17,158,255,0) 52.97%, rgba(17,158,255,0) 53.30%, rgba(17,158,255,0) 53.63%, rgba(17,158,255,0) 53.96%, rgba(17,158,255,0) 54.29%, rgba(17,158,255,0) 54.62%, rgba(17,158,255,0) 55%);">
              </rs-layer><rs-layer id="slider-2-slide-4-layer-19" class="rs-pxl-5" data-type="shape"
                  data-rsp_ch="on" data-xy="xo:-650px,-536px,-407px,-251px;yo:-650px,-536px,-407px,-251px;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                  data-dim="w:1200px,990px,752px,463px;h:1200px,990px,752px,463px;"
                  data-frame_0="y:100px,82px,62px,38px;" data-frame_1="sp:1000;"
                  data-frame_999="o:0;st:w;sR:8000;"
                  style="z-index:7;background:radial-gradient(ellipse at center, rgba(17,158,255,1) 0%, rgba(17,158,254,0.99) 4.67%, rgba(17,157,252,0.96) 9.34%, rgba(18,155,248,0.9) 14.01%, rgba(19,154,244,0.83) 18.68%, rgba(20,152,238,0.75) 23.35%, rgba(21,149,232,0.65) 28.02%, rgba(22,146,225,0.55) 32.69%, rgba(23,144,218,0.45) 37.36%, rgba(24,141,211,0.35) 42.03%, rgba(25,139,205,0.25) 46.70%, rgba(26,136,199,0.17) 51.37%, rgba(27,135,195,0.1) 56.04%, rgba(28,133,191,0.04) 60.71%, rgba(28,132,189,0.01) 65.38%, rgba(28,132,188,0) 70%, rgba(28,132,188,0) 70.33%, rgba(28,132,188,0) 70.66%, rgba(28,132,188,0) 70.99%, rgba(28,132,187,0) 71.32%, rgba(28,132,187,0) 71.65%, rgba(28,131,186,0) 71.98%, rgba(28,131,186,0) 72.31%, rgba(29,131,185,0) 72.64%, rgba(29,131,185,0) 72.97%, rgba(29,131,184,0) 73.30%, rgba(29,130,184,0) 73.63%, rgba(29,130,184,0) 73.96%, rgba(29,130,183,0) 74.29%, rgba(29,130,183,0) 74.62%, rgba(29,130,183,0) 75%);">
              </rs-layer><rs-layer id="slider-2-slide-4-layer-20"
                  class="tp-shape tp-shapewrapper tp-thecluster" data-type="shape" data-rsp_ch="on"
                  data-xy="x:r,r,r,c;xo:-200px,-165px,-125px,0;y:m,m,m,t;yo:0,0,0,-200px;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                  data-dim="w:1000px,825px,626px,500px;h:1000px,825px,626px,500px;" data-vbility="t,t,f,f"
                  data-frame_0="sX:0;sY:0;" data-frame_1="e:power4.out;sp:1500;"
                  data-frame_999="o:0;st:w;sR:7500;"
                  data-clusterdata='ms:5%;mi:10;mp:24;ma:500;sf:random3D;mc:direction;mn:1;mf:109;mm:1;mm2:1;mm3:1;g1X:-20;g2X:0;g3X:20;gl:1;gv:11;t1:1;t2:;t3:1;sIX:0;sIY:0;sVX:0;sVY:4;pc:radial-gradient(ellipse at center, rgba(5,61,122,1) 0%, rgba(5,61,122,1) 50%, rgba(29,130,183,1) 75%, rgba(255,124,143,1) 90%, rgba(224,170,97,1) 100%);pax:300%;cim:1%;as:loop;aniY:6;mps:lifetime;ld:20;mg:1;msp:;msv:6;ifm:indivRota;ifr:50;vfx:bokeh;vmi:10;vma:30;'
                  style="z-index:6;background-color:rgba(0,0,0,0.0);">
              </rs-layer> </rs-slide>
          <rs-slide style="position: absolute;" data-key="rs-5" data-title="Slide" data-anim="ms:300ms;"
              data-in="o:0;" data-out="a:false;">
              <img src="/assets/img/transparent.png" alt="Slide" title="..." class="rev-slidebg tp-rs-img"
                  data-bg="c:#ffffff;" data-parallax="off" data-no-retina />
              <rs-group id="slider-2-slide-5-layer-0" data-type="group" data-rsp_ch="on" data-xy="x:c;y:m;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;a:center;" data-dim="w:85%;"
                  data-frame_0="o:1;" data-frame_999="o:0;st:w;sR:8700;sA:9000;" style="z-index:8;"><rs-layer
                      id="slider-2-slide-5-layer-18" class="rs-pxl-4" data-type="shape" data-rsp_ch="on"
                      data-xy="x:c;xo:212px,175px,132px,81px;yo:91px,75px,56px,34px;" data-pos="a"
                      data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                      data-dim="w:409px,337px,256px,157px;h:10,8,6,3;" data-clip="u:true;"
                      data-frame_0="x:0%;o:1;cp:0%;" data-frame_1="e:power4.inOut;st:300;sp:1000;sR:300;"
                      data-frame_999="o:0;st:w;sR:7700;"
                      style="z-index:13;background:linear-gradient(90deg, rgba(252,65,162,1) 0%, rgba(28,144,216,1) 100%);">
                  </rs-layer><rs-layer id="slider-2-slide-5-layer-5" class="rs-pxl-3 rs-pxmask"
                      data-type="text" data-color="#03060b" data-rsp_ch="on" data-xy="y:m;" data-pos="r"
                      data-text="w:normal;s:100,82,62,38;l:100,82,62,38;fw:700;a:center;" data-frame_0="o:1;"
                      data-frame_0_words="d:5;x:cyc(-20|20);o:0;" data-frame_1="e:power4.out;sp:1000;"
                      data-frame_1_words="d:5;" data-frame_999="o:0;st:w;sR:7750;"
                      style="z-index:12;font-family:'Inter';">Desktop-as-Code, Batteries Included
                  </rs-layer><rs-layer id="slider-2-slide-5-layer-1" data-type="text" data-color="#35404e"
                      data-tsh="h:1px,0px,0px,0px;v:1px,0px,0px,0px;b:1px,0px,0px,0px;" data-rsp_ch="on"
                      data-xy="y:m;" data-pos="r" data-text="w:normal;s:25,20,15,20;l:35,28,21,25;a:center;"
                      data-disp="inline-block" data-margin="t:24,20,15,20;b:24,20,15,30;"
                      data-padding="r:20,17,13,50;l:20,17,13,50;" data-frame_1="st:500;sp:1000;sR:500;"
                      data-frame_999="o:0;st:w;sR:7500;"
                      style="z-index:11;font-family:'Inter';display:inline-block;">Embark on a journey where
                      innovation, empowerment, and transformation converge. Engage with our dynamic community
                      and explore our expertly-crafted desktop provisioning model. Together, we will connect
                      the dots of groundbreaking configurations, software, and cloud services.
                  </rs-layer><rs-layer id="slider-2-slide-5-layer-17" class="rev-btn" data-type="button"
                      data-color="#03060b" data-rsp_ch="on"
                      data-xy="xo:913px,753px,572px,352px;yo:446px,368px,279px,172px;" data-pos="r"
                      data-text="w:normal;s:40,33,25,25;l:80,66,50,35;fw:700;"
                      data-dim="minh:0px,none,none,none;"
                      data-actions='o:click;a:scrollbelow;sp:1000ms;e:power1.inOut;' data-disp="inline-block"
                      data-border="bos:solid;boc:#fc41a2;bow:0,0,2px,0;" data-frame_0="sX:2;sY:2;"
                      data-frame_1="st:1500;sp:1000;sR:1500;" data-frame_999="o:0;st:w;sR:6500;"
                      data-frame_hover="sX:1.1;sY:1.1;c:#000;boc:#1c90d8;bor:0px,0px,0px,0px;bos:solid;bow:0,0,2px,0;e:power1.inOut;"
                      style="z-index:6;font-family:'Inter';display:inline-block;">Start Your AI Journey
                  </rs-layer></rs-group><rs-layer id="slider-2-slide-5-layer-2"
                  class="tp-shape tp-shapewrapper tp-thecluster" data-type="shape" data-rsp_ch="on"
                  data-xy="x:c;" data-text="w:normal;s:20,16,12,7;l:0,20,15,9;" data-dim="w:100%;h:100%;"
                  data-basealign="slide" data-frame_0="sX:0;sY:0;" data-frame_1="e:power4.out;sp:1500;"
                  data-frame_999="o:0;st:w;sR:7500;"
                  data-clusterdata='ms:15%;mi:12;mp:50;ma:2000;mc:normalCW;sz:-9;mm2:10;g2X:0;g3X:5;gl:1;gv:7;pc:radial-gradient(ellipse at center, rgba(255,236,33,1) 0%, rgba(28,144,216,1) 25%, rgba(252,65,162,1) 50%, rgba(252,65,162,1) 100%);po:;cim:1%;mps:lifetime;ld:20;msp:;msv:1;vma:20;'
                  style="z-index:7;background-color:rgba(0,0,0,0.0);">
              </rs-layer><rs-layer id="slider-2-slide-5-layer-21"
                  class="tp-shape tp-shapewrapper tp-thecluster" data-type="shape" data-rsp_ch="on"
                  data-xy="x:c;" data-text="w:normal;s:20,16,12,7;l:0,20,15,9;" data-dim="w:100%;h:100%;"
                  data-vbility="t,t,f,f" data-basealign="slide" data-frame_0="sX:0;sY:0;"
                  data-frame_1="e:power4.out;sp:1500;" data-frame_999="o:0;st:w;sR:7500;"
                  data-clusterdata='ms:10%;mi:10;mp:50;ma:1000;mc:normalCW;sz:-9;mm2:10;g2X:0;g3X:5;pc:radial-gradient(ellipse at center, rgba(255,236,33,1) 0%, rgba(28,144,216,1) 25%, rgba(252,65,162,1) 50%, rgba(252,65,162,1) 100%);po:;cim:1%;mps:lifetime;ld:20;mg:1;msp:;msv:1;ifm:;vfx:bokeh;vbr:;'
                  style="z-index:6;background-color:rgba(0,0,0,0.0);">
              </rs-layer> </rs-slide>
          <rs-slide style="position: absolute;" data-key="rs-6" data-title="Slide" data-anim="ms:300ms;"
              data-in="o:0;" data-out="a:false;">
              <img src="/assets/img/transparent.png" alt="Slide" title="..." class="rev-slidebg tp-rs-img"
                  data-bg="c:linear-gradient(300deg, rgba(116,0,184,1) 0%, rgba(105,48,195,1) 30%, rgba(94,96,206,1) 60%, rgba(100,223,223,1) 100%);"
                  data-parallax="off" data-no-retina />
              <rs-group id="slider-2-slide-6-layer-0" data-type="group" data-rsp_ch="on"
                  data-xy="x:c;y:m,m,m,t;yo:0,0,0,260px;"
                  data-text="w:normal;s:20,16,12,7;l:0,20,15,9;a:center;" data-dim="w:85%,85%,85%,100%;"
                  data-frame_0="o:1;" data-frame_999="o:0;st:w;sR:8700;sA:9000;" style="z-index:8;"><rs-layer
                      id="slider-2-slide-6-layer-18" class="rs-pxl-4" data-type="shape" data-rsp_ch="on"
                      data-xy="x:c;yo:90px,74px,56px,34px;" data-pos="a"
                      data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                      data-dim="w:387px,319px,242px,149px;h:10,8,6,3;" data-clip="u:true;"
                      data-frame_0="x:0%;o:1;cp:0%;" data-frame_1="e:power4.inOut;st:300;sp:1000;sR:300;"
                      data-frame_999="o:0;st:w;sR:7700;"
                      style="z-index:13;background:linear-gradient(90deg, rgba(128,255,219,1) 0%, rgba(78,168,222,1) 100%);">
                  </rs-layer><rs-layer id="slider-2-slide-6-layer-5" class="rs-pxl-3" data-type="text"
                      data-rsp_ch="on" data-xy="y:m;" data-pos="r"
                      data-text="w:normal;s:100,82,62,38;l:100,82,62,38;fw:700;a:center;" data-frame_0="o:1;"
                      data-frame_0_lines="d:5;x:cyc(20|-20);o:0;" data-frame_1="e:power4.out;sp:1000;"
                      data-frame_1_lines="d:10;" data-frame_999="o:0;st:w;sR:7700;"
                      style="z-index:12;font-family:'Inter';">Unleash<br />
                      The Power Of<br />
                      AI-Integration
                  </rs-layer><rs-layer id="slider-2-slide-6-layer-1" data-type="text"
                      data-color="rgba(255, 255, 255, 0.81)"
                      data-tsh="c:rgba(255,255,255,0.25);h:1px,0px,0px,0px;v:1px,0px,0px,0px;b:1px,0px,0px,0px;"
                      data-rsp_ch="on" data-xy="y:m;" data-pos="r"
                      data-text="w:normal;s:25,20,15,20;l:35,28,21,25;a:center;"
                      data-margin="t:24,20,15,20;b:24,20,15,30;" data-padding="r:0,0,0,30;l:0,0,0,30;"
                      data-frame_1="st:500;sp:1000;sR:500;" data-frame_999="o:0;st:w;sR:7500;"
                      style="z-index:11;font-family:'Inter';">Elevate your desktop with the transformative
                      power of AI. Our suite of smart applications, advanced AI tools, and customizable
                      options propels you ahead, redefining productivity and innovation. Stay ahead, stand
                      out.
                  </rs-layer><rs-layer id="slider-2-slide-6-layer-17" class="rev-btn" data-type="button"
                      data-color="#7400b8"
                      data-bsh="c:rgba(255,255,255,0.14);h:1px,0px,0px,0px;v:1px,0px,0px,0px;b:1px,0px,0px,0px;s:1px,0px,0px,0px;"
                      data-rsp_ch="on" data-xy="x:c;y:b;yo:-120px,-99px,-75px,-50px;" data-pos="r"
                      data-text="w:normal;s:24,19,14,15;l:69,56,42,40;ls:4px,3px,2px,1px;fw:700;a:center;"
                      data-dim="minh:0px,none,none,none;"
                      data-actions='o:click;a:scrollbelow;sp:1000ms;e:power1.inOut;' data-disp="inline-block"
                      data-padding="r:24,20,15,20;l:24,20,15,20;" data-border="bor:50px,50px,50px,50px;"
                      data-clip="u:true;" data-frame_0="x:0%;o:1;cp:0%;"
                      data-frame_1="e:power4.out;st:1500;sp:1000;" data-frame_999="o:0;st:w;sR:6500;"
                      data-frame_hover="c:#fff;bgc:linear-gradient(90deg, rgba(128,255,219,1) 0%, rgba(78,168,222,1) 100%);bor:50px,50px,50px,50px;e:power1.inOut;"
                      style="z-index:6;background:linear-gradient(90deg, rgba(78,168,222,1) 0%, rgba(128,255,219,1) 100%);font-family:'Inter';text-transform:uppercase;display:inline-block;"><i
                          class="fa-flash" style="margin-right: 8px; margin-left: 8px;"></i> Begin Your
                      Adventure
                  </rs-layer></rs-group><rs-layer id="slider-2-slide-6-layer-2"
                  class="tp-shape tp-shapewrapper tp-thecluster" data-type="shape" data-rsp_ch="on"
                  data-xy="x:c;xo:1px,0,0,0;y:m;yo:-1px,0,0,0;" data-text="w:normal;s:20,16,12,7;l:0,20,15,9;"
                  data-dim="w:100%;h:100%;" data-basealign="slide" data-frame_0="sX:1.5;sY:1.5;"
                  data-frame_1="e:power4.out;sp:1500;" data-frame_999="o:0;st:w;sR:7500;"
                  data-clusterdata='ms:4%;mi:10;ma:300;mc:random;mn:1;mf:282;sz:7;mm:100;mm2:100;mm3:100;g1X:-10;g2X:0;g3X:10;gv:11;sIX:3;sIY:3;sIZ:3;sVX:10;sVY:-6;sM:4;pc:linear-gradient(170deg, rgba(100,223,223,1) 0%, rgba(128,255,219,1) 100%);po:;cim:1;aniY:20;mps:lifetime;ld:2;mp1:xy;mp2:xy;mp3:xy;msp:;msv:1;ifm:indivRota;ifr:10;vbr:;vma:20;'
                  style="z-index:7;background-color:rgba(0,0,0,0.0);">
              </rs-layer><rs-layer id="slider-2-slide-6-layer-22"
                  class="tp-shape tp-shapewrapper tp-thecluster" data-type="shape" data-rsp_ch="on"
                  data-xy="x:c;y:m;" data-text="w:normal;s:20,16,12,7;l:0,20,15,9;" data-dim="w:100%;h:100%;"
                  data-vbility="t,t,f,f" data-basealign="slide" data-frame_0="sX:1.5;sY:1.5;"
                  data-frame_1="e:power4.out;sp:1500;" data-frame_999="o:0;st:w;sR:7500;"
                  data-clusterdata='ms:3%;mi:25;ma:200;mc:random;mn:1;mf:282;sz:7;mm:100;mm2:100;mm3:100;g1X:-10;g2X:0;g3X:10;gv:11;sIX:3;sIY:3;sIZ:3;sVX:10;sVY:-6;sM:4;pc:linear-gradient(170deg, rgba(100,223,223,1) 0%, rgba(128,255,219,1) 100%);po:;cim:1;aniY:20;mps:lifetime;ld:10;mg:1;mp1:xy;mp2:xy;mp3:xy;msp:;msv:1;ifm:indivRota;ifr:5;vfx:bokeh;vbr:;vma:20;'
                  style="z-index:6;background-color:rgba(0,0,0,0.0);">
              </rs-layer> </rs-slide>
      </rs-slides>
  </rs-module>
</rs-module-wrap>
`;

  onScriptLoaded() {
    this.scriptsLoaded++
    if (this.scriptsLoaded === 3) {
      const interv = setInterval(() => {
        if (window.location.pathname === '/') {
          clearInterval(interv)
          document.body.classList.add('home')
          setTimeout(() => {
            setInterval(() => {
              if (document.body.classList.contains('home')) {
                const btnsContainer: any = document.getElementsByClassName('btns-container')
                if (btnsContainer.length) {
                  const addBtnsContainer = document.getElementsByClassName('add-buttons')
                  if (addBtnsContainer.length) {
                    btnsContainer[0].style.setProperty(
                      'top',
                      addBtnsContainer[0].getBoundingClientRect().top +
                      addBtnsContainer[0].getBoundingClientRect().height -
                      document.body.getBoundingClientRect().y +
                      30 +
                      'px'
                    )
                  }
                }
              }
            }, 100)
            if (window.RS_MODULES === undefined) window.RS_MODULES = {}
            if (RS_MODULES.modules === undefined) RS_MODULES.modules = {}
            RS_MODULES.modules['aiidslider'] = {
              once: RS_MODULES.modules['aiidslider'] !== undefined ? RS_MODULES.modules['aiidslider'].once : undefined,
              init: function () {
                window.revapi2 =
                  window.revapi2 === undefined || window.revapi2 === null || window.revapi2.length === 0
                    ? document.getElementById('ai-id-slider')
                    : window.revapi2
                if (window.revapi2 === null || window.revapi2 === undefined || window.revapi2.length == 0) {
                  window.revapi2initTry = window.revapi2initTry === undefined ? 0 : window.revapi2initTry + 1
                  if (window.revapi2initTry < 20)
                    requestAnimationFrame(function () {
                      RS_MODULES.modules['aiidslider'].init()
                    })
                  return
                }
                window.revapi2 = jQuery(window.revapi2)
                if (window.revapi2.revolution == undefined) {
                  revslider_showDoubleJqueryError('ai-id-slider')
                  return
                }
                revapi2.revolutionInit({
                  revapi: 'revapi2',
                  DPR: 'ax4',
                  sliderLayout: 'fullscreen',
                  visibilityLevels: '1240,1024,778,480',
                  gridwidth: '1240,1024,778,480',
                  gridheight: '900,768,960,720',
                  minHeight: '300px',
                  perspective: 600,
                  perspectiveType: 'isometric',
                  keepBPHeight: true,
                  observeWrap: false,
                  editorheight: '900,768,960,720',
                  responsiveLevels: '1240,1024,778,480',
                  ignoreHeightChange: false,
                  fullScreenOffset: '64px',
                  stopAtSlide: 1,
                  stopAfterLoops: 0,
                  stopLoop: true,
                  progressBar: { disableProgressBar: true },
                  navigation: {
                    keyboardNavigation: true,
                    wheelCallDelay: 1000,
                    onHoverStop: false,
                    touch: {
                      touchenabled: true,
                      touchOnDesktop: true,
                    },
                    arrows: {
                      enable: true,
                      style: 'clean_arrows',
                      left: {
                        h_offset: 0,
                      },
                      right: {
                        h_offset: 10,
                      },
                    },
                  },
                  scrolleffect: {
                    set: true,
                    fade: true,
                    blur: true,
                    maxblur: 14,
                    multiplicator: 1.81,
                    multiplicator_layers: 1.81,
                    tilt: '40%',
                  },
                  sbtimeline: {
                    set: false,
                  },
                  viewPort: {
                    global: false,
                    enable: false,
                  },
                  fallbacks: {
                    allowHTML5AutoPlayOnAndroid: true,
                  },
                })
                revapi2.bind('revolution.slide.onbeforeswap', function (e, data) {
                  const btnsContainer: any = document.getElementsByClassName('btns-container')
                  if (btnsContainer.length) {
                    if (data.nextSlideIndex === 1) {
                      btnsContainer[0].classList.remove('hide-buttons')
                    } else {
                      btnsContainer[0].classList.add('hide-buttons')
                    }
                  }
                })
                if (revapi2 !== undefined)
                  jQuery.fn.revolution.theClusterInit(revapi2[0].id, {
                    url: 'https://wordpress.megabyte.space/wp-content/plugins/revslider-thecluster-addon/',
                  })
              },
            } // End of RevInitScript
            if (window.RS_MODULES.checkMinimal !== undefined) {
              window.RS_MODULES.checkMinimal()
            }
          }, 0)
        }
      }, 50)
    }
  }

  importResources() {
    if (!this.isTouchscreen) {
      window.RS_MODULES = window.RS_MODULES || {}
      window.RS_MODULES.modules = window.RS_MODULES.modules || {}
      window.RS_MODULES.waiting = window.RS_MODULES.waiting || []
      window.RS_MODULES.defered = true
      window.RS_MODULES.waiting = window.RS_MODULES.waiting.concat(['thecluster', 'threejs'])
      window.RS_MODULES.moduleWaiting = window.RS_MODULES.moduleWaiting || {}
      window.RS_MODULES.type = 'compiled'
      if (!(window as any).jQueryLoaded) {
        if (Build.isServer) return;
        (window as any).jQueryLoaded = true
        importResource({ propertyName: 'three', link: '/assets/js/three.min.js', defer: true }, () => {
          this.onScriptLoaded()
        })
        importResource({ propertyName: 'rs6', link: '/assets/js/rs6.min.js', defer: true }, () => {
          this.onScriptLoaded()
        })
        importResource({ propertyName: 'rbtools', link: '/assets/js/rbtools.min.js', defer: true }, () => {
          this.onScriptLoaded()
        })
      }
    }
  }
  componentDidLoad() {
    if (!this.isTouchscreen) {
      this.importResources()
    }
    if (document.location.hash) {
      const hashId = document.location.hash.substring(1)
      setTimeout(() => {
        const element = document.getElementById(hashId)
        if (element) {
          setTimeout(() => {
            element.scrollIntoView({ behavior: 'smooth' })
            setTimeout(() => {
              element.scrollIntoView({ behavior: 'smooth' })
            }, 667)
          }, 667)
        }
      }, 333)
    }
  }

  showEmail(e) {
    if (!this.showCommunity) {
      e.preventDefault()
      this.showEmailInput = true
      const parallaxInput = document.getElementById('parallax-input')
      if (parallaxInput) {
        parallaxInput.focus()
      }
    }
  }

  inputBlur(ev) {
    this.showEmailInput = false
  }

  scrollWelcome(ev) {
    const startEl = document.getElementById('welcome')
    setTimeout(() => {
      if (startEl) {
        startEl.scrollIntoView({ behavior: 'smooth' })
        setTimeout(() => {
          startEl.scrollIntoView({ behavior: 'smooth' })
        }, 667)
      }
    }, 667)
  }

  /*render() {
    return (
      <site-root>
        <div id="slider" innerHTML={this.isTouchscreen ? '' : this.fullScreenSliderHTML}></div>
        <div class={`page-theme--${state.pageTheme}`}>
          <Routes />
        </div>
        <div class={{ hidesplash: this.isTouchscreen }}>
          <div class="btns-container alt-btns">
            <div class="btns">
              <Button
                class="reveal step-5"
                kind="round"
                color="indigo"
                variation="light"
                href={this.showCommunity ? '/community' : ''}
                onClick={(e) => this.showEmail(e)}
                anchor={true}
              >
                {this.showCommunity ? 'Join Community' : 'Get Beta Access'} <span>{'->'}</span>
              </Button>
              <Button
                class="reveal step-6"
                kind="round"
                color="indigo"
                href="#welcome"
                onClick={(ev) => {
                  this.scrollWelcome(ev)
                }}
                rel="noopener"
                anchor={true}
              >
                Learn More <span>{'->'}</span>
              </Button>
              {!this.isTouchscreen && (
                <newsletter-signup-parallax
                  defaults={defaults}
                  onSubmissionSuccess={() => {
                    this.showCommunity = true
                  }}
                  onEmailInputBlur={(ev) => {
                    this.inputBlur(ev)
                  }}
                  class={{
                    open: this.showEmailInput,
                  }}
                />
              )}
            </div>
          </div>
        </div>
      </site-root>
    )
  }*/
  render() {
    return (
      <site-root>
        <div class={`page-theme--${state.pageTheme}`}>
          <Routes />
        </div>
      </site-root>
    );
  }
}
