(function () {
  "use strict";

  // ---- Mobile / tablet menu (nav links + topics) --------------------------
  var topicsToggle = document.querySelector("[data-topics-toggle]");
  var mobileTopics = document.getElementById("mobile-topics");

  if (topicsToggle && mobileTopics) {
    topicsToggle.addEventListener("click", function () {
      var isOpen = !mobileTopics.hasAttribute("hidden");
      if (isOpen) {
        mobileTopics.setAttribute("hidden", "");
        topicsToggle.setAttribute("aria-expanded", "false");
      } else {
        mobileTopics.removeAttribute("hidden");
        topicsToggle.setAttribute("aria-expanded", "true");
      }
    });
  }

  // ---- Search --------------------------------------------------------------
  // Pagefind is generated at build/deploy time (see .github/workflows/deploy.yml),
  // so /pagefind/pagefind-ui.js only exists once the site has been indexed.
  // PagefindUI renders its own input + results dropdown directly inline, so
  // no custom modal markup is needed.
  function initSearch() {
    var mount = document.getElementById("header-search");
    if (!mount || typeof PagefindUI === "undefined") return;
    new PagefindUI({
      element: "#header-search",
      showSubResults: true,
      showImages: false,
      resetStyles: true,
      translations: { placeholder: "Search posts..." },
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initSearch);
  } else {
    initSearch();
  }
})();
