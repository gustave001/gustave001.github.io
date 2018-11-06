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

<nav class="site-nav menuTool">
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

    {% if theme.menu_tool.enable %}
      <li class="menu-item menu-item-briefcase">
        <a  href="#">
          <i class="menu-item-icon fa fa-briefcase fa-fw"></i> <br />
          {{ __('工具') }}
        </a>
        <ul>
          {% for obj in theme.tool_detail %}
            <li class="dropdown">
              {% for name,value in obj %}
                {% if name=='key' %}
                  <a href="#" >{{value}}</a>
                {% endif %}
              {% endfor %}
                <ul>
                  {% for name,path in obj %}
                    {% if name!='key' %}
                      <li>
                        <a href={{path}} target="_blank">{{name}}</a>
                      </li>
                    {% endif %}
                  {% endfor %}
                </ul>
            </li>
          {% endfor %}
        </ul>
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


