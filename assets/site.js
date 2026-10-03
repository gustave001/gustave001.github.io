(() => {
  const root = document.documentElement.dataset.siteRoot || ".";
  const currentPath = document.documentElement.dataset.pagePath || "";
  const pages = [
    ["总览", "资料总目录", "pages/考试资料总目录.html"],
    ["总览", "2027 考场策略与 10 天计划", "pages/2027江西省考行测考场策略与10天启动计划.html"],
    ["政治理论", "政治理论方法与每日积累卡", "pages/政治理论/政治理论方法与每日积累卡.html"],
    ["常识判断", "常识判断框架与考场速查卡", "pages/常识判断/常识判断框架与考场速查卡.html"],
    ["言语理解", "言语理解方法与考场速查卡", "pages/言语理解/言语理解方法与考场速查卡.html"],
    ["言语理解", "技巧导航与选择顺序", "pages/言语理解/技巧方法/00-技巧导航与选择顺序.html"],
    ["言语理解", "文段结构与重点定位", "pages/言语理解/技巧方法/01-文段结构与重点定位.html"],
    ["言语理解", "主旨、意图与标题", "pages/言语理解/技巧方法/02-主旨意图与标题.html"],
    ["言语理解", "细节、推断与选项陷阱", "pages/言语理解/技巧方法/03-细节推断与选项陷阱.html"],
    ["言语理解", "逻辑填空与语境呼应", "pages/言语理解/技巧方法/04-逻辑填空与语境呼应.html"],
    ["言语理解", "语句填空与下文推断", "pages/言语理解/技巧方法/05-语句填空与下文推断.html"],
    ["言语理解", "语句排序与捆绑", "pages/言语理解/技巧方法/06-语句排序与捆绑.html"],
    ["言语理解", "词句理解与代词指代", "pages/言语理解/技巧方法/07-词句理解与代词指代.html"],
    ["言语理解", "文章阅读与考场策略", "pages/言语理解/技巧方法/08-文章阅读与考场策略.html"],
    ["数量关系", "方法、公式与考场白名单", "pages/数量关系/数量关系方法、公式与考场白名单.html"],
    ["数量关系", "题型导航与考场选择", "pages/数量关系/题型方法/00-题型导航与考场选择.html"],
    ["数量关系", "方程、比例与鸡兔同笼", "pages/数量关系/题型方法/01-方程比例与鸡兔同笼.html"],
    ["数量关系", "工程与牛吃草", "pages/数量关系/题型方法/02-工程与牛吃草.html"],
    ["数量关系", "行程问题", "pages/数量关系/题型方法/03-行程问题.html"],
    ["数量关系", "经济利润", "pages/数量关系/题型方法/04-经济利润.html"],
    ["数量关系", "浓度与混合", "pages/数量关系/题型方法/05-浓度与混合.html"],
    ["数量关系", "容斥原理", "pages/数量关系/题型方法/06-容斥原理.html"],
    ["数量关系", "排列组合与概率", "pages/数量关系/题型方法/07-排列组合与概率.html"],
    ["数量关系", "几何问题", "pages/数量关系/题型方法/08-几何问题.html"],
    ["数量关系", "年龄、日期、钟表与周期", "pages/数量关系/题型方法/09-年龄日期钟表与周期.html"],
    ["数量关系", "植树、方阵、排队与比赛", "pages/数量关系/题型方法/10-植树方阵排队与比赛.html"],
    ["数量关系", "极值、抽屉与最不利构造", "pages/数量关系/题型方法/11-极值抽屉与最不利构造.html"],
    ["数量关系", "数字特性、余数与数列", "pages/数量关系/题型方法/12-数字特性余数与数列.html"],
    ["判断推理", "判断推理方法与考场速查卡", "pages/判断推理/判断推理方法与考场速查卡.html"],
    ["判断推理", "图形推理分类导航与遍历清单", "pages/判断推理/图形推理分类导航与遍历清单.html"],
    ["资料分析", "公式与概念速查卡", "pages/资料分析/资料分析公式与概念速查卡.html"],
    ["资料分析", "速算技巧导航", "pages/资料分析/速算技巧/00-技巧导航与选择顺序.html"],
    ["资料分析", "假设分配法", "pages/资料分析/速算技巧/01-假设分配法.html"],
    ["资料分析", "百化分与份数法", "pages/资料分析/速算技巧/02-百化分与份数法.html"],
    ["资料分析", "截位直除与误差控制", "pages/资料分析/速算技巧/03-截位直除与误差控制.html"],
    ["资料分析", "化除为乘与小增长率近似", "pages/资料分析/速算技巧/04-化除为乘与小增长率近似.html"],
    ["资料分析", "分数比较三板斧", "pages/资料分析/速算技巧/05-分数比较三板斧.html"],
    ["资料分析", "增长量比较速判", "pages/资料分析/速算技巧/06-增长量比较速判.html"],
    ["资料分析", "十字交叉与混合增长率", "pages/资料分析/速算技巧/07-十字交叉与混合增长率.html"],
    ["申论", "县乡申论方法、题型与复盘手册", "pages/申论/县乡申论方法、题型与复盘手册.html"],
    ["维护", "HTML 知识站维护说明", "维护说明.html"]
  ];

  const normalize = value => decodeURIComponent(value || "").replace(/^\.\//, "").replace(/^\//, "");
  const activePath = normalize(currentPath);
  const nav = document.querySelector("#site-nav");
  const groups = [...new Set(pages.map(page => page[0]))];

  function renderNav(query = "") {
    if (!nav) return;
    const keyword = query.trim().toLowerCase();
    nav.innerHTML = "";
    let matchCount = 0;
    groups.forEach(group => {
      const matches = pages.filter(page => page[0] === group && (!keyword || `${page[0]} ${page[1]}`.toLowerCase().includes(keyword)));
      if (!matches.length) return;
      matchCount += matches.length;
      const details = document.createElement("details");
      details.className = "nav-group";
      details.open = !!keyword || matches.some(page => normalize(page[2]) === activePath) || ["总览", "言语理解", "数量关系", "资料分析"].includes(group);
      const summary = document.createElement("summary");
      summary.textContent = group;
      const items = document.createElement("div");
      items.className = "nav-items";
      matches.forEach(([, title, path]) => {
        const link = document.createElement("a");
        link.className = `nav-link${normalize(path) === activePath ? " active" : ""}`;
        link.href = `${root}/${path}`;
        link.textContent = title;
        items.appendChild(link);
      });
      details.append(summary, items);
      nav.appendChild(details);
    });
    if (!matchCount) nav.innerHTML = '<div class="nav-empty">没有匹配的目录项</div>';
  }

  renderNav();
  document.querySelector("#nav-search")?.addEventListener("input", event => renderNav(event.target.value));

  const currentIndex = pages.findIndex(page => normalize(page[2]) === activePath);
  const current = pages[currentIndex];
  const breadcrumbs = document.querySelector("#breadcrumbs");
  if (breadcrumbs && current) {
    breadcrumbs.innerHTML = `<a href="${root}/index.html">知识站</a><span>${current[0]}</span><span>${current[1]}</span>`;
  }

  const pager = document.querySelector("#page-pager");
  if (pager && currentIndex >= 0) {
    const previous = pages[currentIndex - 1];
    const next = pages[currentIndex + 1];
    if (previous) pager.insertAdjacentHTML("beforeend", `<a href="${root}/${previous[2]}"><small>← 上一页</small><strong>${previous[1]}</strong></a>`);
    else pager.insertAdjacentHTML("beforeend", "<span></span>");
    if (next) pager.insertAdjacentHTML("beforeend", `<a href="${root}/${next[2]}"><small>下一页 →</small><strong>${next[1]}</strong></a>`);
  }

  const backButton = document.querySelector("#back-button");
  backButton?.addEventListener("click", () => {
    if (history.length > 1 && document.referrer) history.back();
    else location.href = `${root}/index.html`;
  });

  const menuButton = document.querySelector("#menu-button");
  const scrim = document.querySelector("#sidebar-scrim");
  const closeSidebar = () => {
    document.body.classList.remove("sidebar-open");
    menuButton?.setAttribute("aria-expanded", "false");
    if (scrim) scrim.hidden = true;
  };
  menuButton?.addEventListener("click", () => {
    const opening = !document.body.classList.contains("sidebar-open");
    document.body.classList.toggle("sidebar-open", opening);
    menuButton.setAttribute("aria-expanded", String(opening));
    if (scrim) scrim.hidden = !opening;
  });
  scrim?.addEventListener("click", closeSidebar);
  document.addEventListener("keydown", event => { if (event.key === "Escape") closeSidebar(); });
  document.querySelector("#scroll-top")?.addEventListener("click", () => scrollTo({ top: 0, behavior: "smooth" }));

  document.querySelectorAll(".prose a[href$='.md']").forEach(link => {
    link.href = link.getAttribute("href").replace(/\.md($|#)/, ".html$1");
  });
})();
