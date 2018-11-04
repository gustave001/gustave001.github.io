<div class="site-brand-wrapper">
  <div class="site-meta {% if theme.custom_logo.enabled %}custom-logo{% endif %}">
    {% if theme.custom_logo.image and theme.scheme === 'Muse' %}
      <div class="site-meta-headline">
        <a>
          <img class="custom-logo-image" src="{{ theme.custom_logo.image }}"
               alt="{{ config.title }}"/>
        </a>
      </div>
    {% endif %}

    <div class="custom-logo-site-title">
      <a href="{{ config.root }}"  class="brand" rel="start">
        <span class="logo-line-before"><i></i></span>
        <span class="site-title">{{ config.title }}</span>
        <span class="logo-line-after"><i></i></span>
      </a>
    </div>
      {% if theme.seo %}
        <h1 class="site-subtitle" itemprop="description">{{ config.subtitle }}</h1>
      {% else %}
        <p class="site-subtitle">{{ config.subtitle }}</p>
      {% endif %}
  </div>

  <div class="site-nav-toggle">
    <button>
      <span class="btn-bar"></span>
      <span class="btn-bar"></span>
      <span class="btn-bar"></span>
    </button>
  </div>
</div>

<nav class="site-nav">
  {% set hasSearch = theme.swiftype_key || theme.algolia_search.enable || theme.tinysou_Key || theme.local_search.enable %}

  {% if theme.menu %}
    <ul id="menu" class="menu">

      {% for name, path in theme.menu %}
        {% set itemName = name.toLowerCase() %}
        <li class="menu-item menu-item-{{ itemName | replace(' ', '-') }}">
          <a href="{{ url_for(path.split('||')[0]) | trim }}" rel="section">
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-fw fa-{{ path.split('||')[1] | trim | default('question-circle') }}"></i> <br />
            {% endif %}
            {{ __('menu.' + name) | replace('menu.', '') }}
          </a>
        </li>
      {% endfor %}

        <li class="menu-item menu-item-briefcase">
            <a href="javascript:;" class="st-briefcase-show-outputs">
            <a id="briefcase" href="#">
              <i class="menu-item-icon fa fa-briefcase fa-fw"></i> <br />
            {{ __('工具') }}
          </a>
          <ul>
              <li class="dropdown">
                  <a href="#">在线编辑</a>
                  <ul>
                      <li>
                          <a href="https://smallpdf.com/cn/pdf-to-word" target="_blank">
                              PDF 转换器
                          </a>
                      </li>

                      <li>
                          <a href="https://www.bejson.com/jsoneditoronline" target="_blank">
                              JSON 编辑器
                          </a>
                      </li>

                      <li>
                          <a href="https://tool.lu/tables/" target="_blank">
                              MD 表格生成
                          </a>
                      </li>

                      <li>
                          <a href="http://cron.qqe2.com/" target="_blank">
                              CRON 表达式
                          </a>
                      </li>

                      <li>
                          <a href="http://tool.oschina.net/codeformat/html" target="_blank">
                              代码格式化
                          </a>
                      </li>

                      <li>
                          <a href="https://zh.numberempire.com/latexequationeditor.php" target="_blank">
                              公式编辑器
                          </a>
                      </li>

                      <li>
                          <a href="https://cli.im/" target="_blank">
                              二维码生成器
                          </a>
                      </li>

                      <li>
                          <a href="http://tool.chinaz.com/tools/native_ascii.aspx" target="_blank">
                              在线编码转换
                          </a>
                      </li>

                      <li>
                          <a href="http://www.toyaml.com" target="_blank">
                              YAML &lt;-&gt; Properties
                          </a>
                      </li>

                  </ul>
              </li>

              <li class="dropdown">
                  <a href="#">在线服务</a>
                  <ul>

                      <li>
                          <a href="https://www.bootcdn.cn/" target="_blank">
                              Boot CDN
                          </a>
                      </li>

                      <li>
                          <a href="http://cdn.code.baidu.com/" target="_blank">
                              百度 CDN
                          </a>
                      </li>

                      <li>
                          <a href="http://qydev.weixin.qq.com/cdn/cdnjs.html" target="_blank">
                              微信 CDN
                          </a>
                      </li>

                      <li>
                          <a href="https://servers.ustclug.org/2014/06/blog-googlefonts-speedup/" target="_blank">
                              科大谷歌字体加速
                          </a>
                      </li>

                  </ul>
              </li>

              <li class="dropdown">
                  <a href="#">开源镜像</a>
                  <ul>

                      <li>
                          <a href="https://opsx.alibaba.com/" target="_blank">
                              OPSX
                          </a>
                      </li>

                      <li>
                          <a href="https://mirror.azure.cn/" target="_blank">
                              AZURE
                          </a>
                      </li>

                      <li>
                          <a href="https://hub.docker.com/" target="_blank">
                              Docker HUB
                          </a>
                      </li>

                  </ul>
              </li>

              <li class="dropdown">
                  <a href="#">在线文档</a>
                  <ul>

                      <li>
                          <a href="https://cn.vuejs.org/v2/api/" target="_blank">
                              vue
                          </a>
                      </li>

                      <li>
                          <a href="https://vuex.vuejs.org/zh/api/#vuex-store" target="_blank">
                              vuex
                          </a>
                      </li>

                      <li>
                          <a href="https://www.jquery123.com/" target="_blank">
                              jQuery
                          </a>
                      </li>

                      <li>
                          <a href="http://www.runoob.com/bootstrap/bootstrap-tutorial.html" target="_blank">
                              Bootstrap
                          </a>
                      </li>

                  </ul>
              </li>

              <li class="dropdown">
                  <a href="#">趋势分析</a>
                  <ul>

                      <li>
                          <a href="https://trends.google.com/trends/?geo=US" target="_blank">
                              谷歌趋势
                          </a>
                      </li>

                      <li>
                          <a href="http://index.baidu.com/#/" target="_blank">
                              百度指数
                          </a>
                      </li>

                      <li>
                          <a href="https://tongji.baidu.com/data/browser" target="_blank">
                              百度流量研究院
                          </a>
                      </li>

                  </ul>
              </li>

          </ul>
        </li>

      {% if hasSearch %}
        <li class="menu-item menu-item-search">
          {% if theme.swiftype_key %}
            <a href="javascript:;" class="st-search-show-outputs">
          {% elseif theme.local_search.enable || theme.algolia_search.enable %}
            <a href="javascript:;" class="popup-trigger">
          {% endif %}
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-search fa-fw"></i> <br />
            {% endif %}
            {{ __('menu.search') }}
          </a>
        </li>
      {% endif %}
    </ul>
  {% endif %}

  {% if hasSearch %}
    <div class="site-search">
      {% include 'search.swig' %}
    </div>
  {% endif %}
</nav>

{% include '../_custom/header.swig' %}

<script>
$('.menu > li > ul').each(function() {
            var $window          = $(window);
            var dropDown         = $(this);
            var menu             = dropDown.offset();
            var farRight         = menu.left + dropDown.outerWidth(true);
            var windowWidth      = $window.width();
            var multiColumn      = dropDown.hasClass('multi-column');

            if (farRight > windowWidth && !multiColumn) {
                dropDown.addClass('make-right');
            } else if (farRight > windowWidth && multiColumn) {
                var difference = farRight - windowWidth;
                dropDown.css('margin-left', -(difference));
            }
        });

        $('.module-applet').on('click', function(){
            $(this).toggleClass('active');
        });

        $('.module-applet__body').each(function(){
            var moduleBody = $(this);
            var farRight = moduleBody.offset().left + moduleBody.outerWidth();
            if(farRight > $(window).width()){
                moduleBody.addClass('pos-right');
            }
        });

          $('.menu li').on('click', function(ev){
                    var navItem = $(this),
                        e       = ev || window.event;

                    e.stopPropagation();
                    if (navItem.find('ul').length) {
                        navItem.toggleClass('active');
                    } else {
                        navItem.parents('.active').removeClass('active');
                    }
                });


                $('#briefcase').on('mouseover',function(){
                $(this).parent().find('ul').css('display','block');

                });
 </script>

