import "package:absurd_starter/src/ui/basecoat/combobox.dart" as bc_combobox;
import "package:absurd_starter/src/ui/basecoat/command.dart" as bc_command;
import "package:absurd_starter/src/ui/basecoat/dialog.dart" as bc_dialog;
import "package:absurd_starter/src/ui/basecoat/dropdown_menu.dart" as bc_dropdown;
import "package:absurd_starter/src/ui/basecoat/popover.dart" as bc_popover;
import "package:absurd_starter/src/ui/basecoat/select.dart" as bc_select;
import "package:absurd_starter/src/ui/basecoat/sidebar.dart" as bc_sidebar;
import "package:absurd_starter/src/ui/basecoat/tabs.dart" as bc_tabs;
import "package:absurd_starter/src/ui/basecoat/toast.dart" as bc_toast;
import "package:absurd_starter/src/ui/layout/primary_layout.dart";
import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";
import "package:htmleez/htmleez.dart" as tags;

const _components = <(String, String)>[
  ("accordion", "Accordion"),
  ("alert", "Alert"),
  ("alert-dialog", "Alert Dialog"),
  ("avatar", "Avatar"),
  ("badge", "Badge"),
  ("breadcrumb", "Breadcrumb"),
  ("button", "Button"),
  ("button-group", "Button Group"),
  ("card", "Card"),
  ("checkbox", "Checkbox"),
  ("combobox", "Combobox"),
  ("command", "Command"),
  ("dialog", "Dialog"),
  ("dropdown-menu", "Dropdown Menu"),
  ("empty", "Empty"),
  ("field", "Field"),
  ("input", "Input"),
  ("input-group", "Input Group"),
  ("item", "Item"),
  ("kbd", "Kbd"),
  ("label", "Label"),
  ("native-select", "Native Select"),
  ("pagination", "Pagination"),
  ("popover", "Popover"),
  ("progress", "Progress"),
  ("radio-group", "Radio Group"),
  ("select", "Select"),
  ("scroll-area", "Scroll Area"),
  ("sidebar", "Sidebar"),
  ("skeleton", "Skeleton"),
  ("slider", "Slider"),
  ("spinner", "Spinner"),
  ("switch", "Switch"),
  ("table", "Table"),
  ("tabs", "Tabs"),
  ("textarea", "Textarea"),
  ("theme-switcher", "Theme Switcher"),
  ("toast", "Toast"),
  ("tooltip", "Tooltip"),
];

HTML pageUi() => primaryLayout(
  body([
    $class("min-h-screen bg-background text-foreground antialiased"),
    _componentSidebar(),
    mainTag([
      tags.header([
        $class("sticky top-0 z-40 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80"),
        div([
          $class("mx-auto flex h-14 max-w-screen-2xl items-center gap-3 px-4 lg:px-8"),
          _sidebarToggleButton(iconOnly: true),
          a([
            $href("#top"),
            $class("flex items-center gap-2 font-semibold tracking-tight"),
            span([$class("size-2 rounded-full bg-primary")]),
            "Kitchen Sink".t,
          ]),
          span([$class("badge hidden sm:inline-flex"), $("data-variant")("secondary"), "DEV ONLY".t]),
          span([$class("ml-auto hidden text-xs text-muted-foreground md:inline"), "Basecoat 1.x / Dart".t]),
          button([
            $type("button"),
            $class("btn"),
            $("data-variant")("outline"),
            $("data-size")("icon-sm"),
            $("data-tooltip")("Toggle theme"),
            $("data-side")("bottom"),
            $aria.label("Toggle theme"),
            $("onclick")("window.basecoat.theme.toggle()"),
            Lucide.sun([$class("hidden size-4 dark:block")]),
            Lucide.moon([$class("size-4 dark:hidden")]),
          ]),
        ]),
      ]),
      span([$id("top"), $class("sr-only")]),
      div([
        $class("mx-auto max-w-screen-2xl space-y-6 px-4 py-8 lg:px-8"),
        _accordionSection(),
        _alertSection(),
        _alertDialogSection(),
        _avatarSection(),
        _badgeSection(),
        _breadcrumbSection(),
        _buttonSection(),
        _buttonGroupSection(),
        _cardSection(),
        _checkboxSection(),
        _comboboxSection(),
        _commandSection(),
        _dialogSection(),
        _dropdownSection(),
        _emptySection(),
        _fieldSection(),
        _inputSection(),
        _inputGroupSection(),
        _itemSection(),
        _kbdSection(),
        _labelSection(),
        _nativeSelectSection(),
        _paginationSection(),
        _popoverSection(),
        _progressSection(),
        _radioSection(),
        _selectSection(),
        _scrollAreaSection(),
        _sidebarSection(),
        _skeletonSection(),
        _sliderSection(),
        _spinnerSection(),
        _switchSection(),
        _tableSection(),
        _tabsSection(),
        _textareaSection(),
        _themeSection(),
        _toastSection(),
        _tooltipSection(),
      ]),
    ]),
    bc_toast.toaster(),
  ]),
  seo: const PageSeo(
    title: "UI Kitchen Sink | Absurd Starter",
    description: "Development-only Basecoat component reference.",
  ),
);

HTML _showcase(String id, String title, String description, List<HTML> children) => section([
  $id(id),
  $class("scroll-mt-20 rounded-xl border bg-card"),
  tags.header([
    $class("rounded-t-xl border-b bg-muted/30 px-5 py-4"),
    div([
      $class("flex items-start justify-between gap-4"),
      div([
        h2([$class("font-semibold tracking-tight"), title.t]),
        p([$class("mt-1 text-sm text-muted-foreground"), description.t]),
      ]),
      a([
        $href("#$id"),
        $class("btn shrink-0"),
        $("data-variant")("ghost"),
        $("data-size")("icon-sm"),
        $aria.label("Link to $title"),
        Lucide.link([$class("size-4")]),
      ]),
    ]),
  ]),
  div([$class("p-5 sm:p-6"), ...children]),
]);

HTML _componentSidebar() => bc_sidebar.sidebar(
  id: "ui-component-sidebar",
  label: "Component index",
  header: div([
    $class("flex items-center justify-between gap-2"),
    div([
      $class("flex items-center gap-2 font-semibold"),
      span([$class("size-2 rounded-full bg-primary")]),
      "Components".t,
    ]),
  ]),
  footer: div([$class("text-xs text-muted-foreground"), "Basecoat 1.x sidebar".t]),
  menu: [
    bc_sidebar.SidebarItem(
      type: bc_sidebar.SidebarMenuType.group,
      items: [
        for (final component in _components)
          bc_sidebar.SidebarItem(
            label: component.$2,
            url: "#${component.$1}",
            current: component.$1 == "accordion",
          ),
      ],
    ),
  ],
);

HTML _sidebarToggleButton({bool iconOnly = false}) => button([
  $type("button"),
  $class("btn"),
  $("data-variant")("outline"),
  if (iconOnly) $("data-size")("icon-sm"),
  $("data-tooltip")("Toggle component sidebar"),
  $("data-side")("right"),
  $aria.label("Toggle component sidebar"),
  $("onclick")("document.getElementById('ui-component-sidebar')?.toggle()"),
  Lucide.panelLeft([if (iconOnly) $class("size-4") else $("data-icon")("inline-start")]),
  if (!iconOnly) "Toggle sidebar".t,
]);

HTML _accordionSection() => _showcase("accordion", "Accordion", "Single, multiple, open, and disabled items.", [
  div([
    $class("grid gap-6 lg:grid-cols-2"),
    section([
      $class("accordion"),
      _accordionItem("Can I use native details?", "Yes. Basecoat enhances semantic details and summary elements.", open: true),
      _accordionItem("Does it support keyboard input?", "The native controls retain their built-in keyboard behavior."),
      _accordionItem("Unavailable question", "This item cannot be opened.", disabled: true),
    ]),
    section([
      $class("accordion rounded-lg border px-4"),
      $("data-multiple")(""),
      _accordionItem("Multiple item one", "More than one item may remain open.", open: true),
      _accordionItem("Multiple item two", "This one starts open as well.", open: true),
    ]),
  ]),
]);

HTML _accordionItem(String title, String content, {bool open = false, bool disabled = false}) => details([
  if (open) $open(""),
  if (disabled) $aria.disabled("true"),
  summary([title.t, Lucide.chevronDown()]),
  section([content.p()]),
]);

HTML _alertSection() => _showcase("alert", "Alert", "Default, destructive, action, and custom-color treatments.", [
  div([
    $class("grid items-start gap-4 lg:grid-cols-2"),
    _alert(Lucide.circleCheck(), "Saved successfully", "Your changes are now live."),
    _alert(Lucide.info(), "Heads up", "A new version is available.", action: "Update"),
    _alert(Lucide.circleAlert(), "Payment failed", "Check your card details and try again.", destructive: true),
    div([
      $class("alert border-amber-200 bg-amber-50 text-amber-900 dark:border-amber-900 dark:bg-amber-950 dark:text-amber-50"),
      Lucide.triangleAlert(),
      h2(["Custom warning".t]),
      section(["This uses utility colors on the standard alert.".t]),
    ]),
  ]),
]);

HTML _alert(HTML icon, String title, String description, {bool destructive = false, String? action}) => div([
  $class("alert"),
  if (destructive) $("data-variant")("destructive"),
  icon,
  h2([title.t]),
  section([description.t]),
  if (action != null)
    footer([
      button([$type("button"), $class("btn"), $("data-size")("xs"), action.t]),
    ]),
]);

HTML _alertDialogSection() => _showcase("alert-dialog", "Alert Dialog", "Explicit decisions in default and compact sizes.", [
  div([
    $class("flex flex-wrap gap-3"),
    _alertDialog("ui-alert-dialog", "Delete project?", false),
    _alertDialog("ui-alert-dialog-sm", "Discard draft?", true),
  ]),
]);

HTML _alertDialog(String id, String title, bool compact) => HTML.fragment([
  button([
    $type("button"),
    $class("btn"),
    $("data-variant")(compact ? "outline" : "destructive"),
    $("onclick")("document.getElementById('$id').showModal()"),
    compact ? "Open compact dialog".t : "Open destructive dialog".t,
  ]),
  tags.dialog([
    $id(id),
    $class("alert-dialog"),
    if (compact) $("data-size")("sm"),
    $aria.labelledby("$id-title"),
    $aria.describedby("$id-description"),
    div([
      tags.header([
        figure([Lucide.triangleAlert()]),
        h2([$id("$id-title"), title.t]),
        p([$id("$id-description"), "This action cannot be undone. Choose carefully before continuing.".t]),
      ]),
      footer([
        button([$class("btn"), $("data-variant")("outline"), $("onclick")("this.closest('dialog').close()"), "Cancel".t]),
        button([$class("btn"), $("data-variant")("destructive"), $("onclick")("this.closest('dialog').close()"), "Continue".t]),
      ]),
    ]),
  ]),
]);

HTML _avatarSection() => _showcase("avatar", "Avatar", "Fallbacks, sizes, status badges, and groups.", [
  div([
    $class("flex flex-wrap items-center gap-6"),
    _avatar("sm", "GS"),
    _avatar(null, "AM", online: true),
    _avatar("lg", "RD"),
    div([
      $class("avatar-group"),
      _avatar(null, "GS"),
      _avatar(null, "AM"),
      _avatar(null, "RD"),
      span([$("data-count")(""), "+8".t]),
    ]),
  ]),
]);

HTML _avatar(String? size, String fallback, {bool online = false}) => span([
  $class("avatar"),
  if (size != null) $("data-size")(size),
  span([fallback.t]),
  if (online) span([$class("avatar-badge bg-emerald-500")]),
]);

HTML _badgeSection() => _showcase("badge", "Badge", "All variants, links, icons, and compact counters.", [
  div([
    $class("flex flex-wrap items-center gap-2"),
    for (final variant in [null, "secondary", "outline", "ghost", "destructive"]) span([$class("badge"), if (variant != null) $("data-variant")(variant), (variant ?? "primary").t]),
    span([
      $class("badge"),
      $("data-variant")("outline"),
      Lucide.check([$("data-icon")("inline-start")]),
      "Verified".t,
    ]),
    a([
      $href("#badge"),
      $class("badge"),
      $("data-variant")("secondary"),
      "Linked".t,
      Lucide.arrowRight([$("data-icon")("inline-end")]),
    ]),
    span([$class("badge min-w-5 rounded-full px-1 tabular-nums"), "99+".t]),
  ]),
]);

HTML _breadcrumbSection() => _showcase("breadcrumb", "Breadcrumb", "Semantic ancestors, separators, collapse, and current page.", [
  nav([
    $class("breadcrumb"),
    $aria.label("Breadcrumb"),
    ol([
      li([
        a([$href("#"), "Home".t]),
      ]),
      li([
        $aria.hidden("true"),
        Lucide.chevronRight(),
      ]),
      li([
        span([$aria.hidden("true"), Lucide.ellipsis()]),
      ]),
      li([
        $aria.hidden("true"),
        Lucide.chevronRight(),
      ]),
      li([
        a([$href("#"), "Components".t]),
      ]),
      li([
        $aria.hidden("true"),
        Lucide.chevronRight(),
      ]),
      li([$aria.current("page"), "Breadcrumb".t]),
    ]),
  ]),
]);

HTML _buttonSection() => _showcase("button", "Button", "Every variant across text and icon sizes, plus disabled/loading states.", [
  div([
    $class("space-y-5"),
    for (final size in ["xs", "sm", null, "lg"])
      div([
        $class("flex flex-wrap items-center gap-2"),
        span([$class("w-14 font-mono text-xs text-muted-foreground"), (size ?? "default").t]),
        for (final variant in [null, "secondary", "outline", "ghost", "link", "destructive"]) button([$type("button"), $class("btn"), if (variant != null) $("data-variant")(variant), if (size != null) $("data-size")(size), (variant ?? "primary").t]),
      ]),
    div([
      $class("flex flex-wrap items-center gap-2"),
      for (final size in ["icon-xs", "icon-sm", "icon", "icon-lg"]) button([$type("button"), $class("btn"), $("data-size")(size), $("data-variant")("outline"), $aria.label(size), Lucide.plus()]),
      button([
        $type("button"),
        $class("btn"),
        $disabled(""),
        Lucide.loaderCircle([$("data-icon")("inline-start"), $class("animate-spin")]),
        "Loading".t,
      ]),
      button([$type("button"), $class("btn"), $disabled(""), "Disabled".t]),
    ]),
  ]),
]);

HTML _buttonGroupSection() => _showcase("button-group", "Button Group", "Horizontal, vertical, segmented, and split actions.", [
  div([
    $class("flex flex-wrap items-start gap-5"),
    div([$class("button-group"), $role("group"), $aria.label("Text alignment"), _iconButton(Lucide.alignStartVertical(), "Left"), _iconButton(Lucide.alignCenterVertical(), "Center"), _iconButton(Lucide.alignEndVertical(), "Right")]),
    div([
      $class("button-group"),
      $role("group"),
      $aria.label("Save actions"),
      button([$class("btn"), "Save".t]),
      hr([$role("separator")]),
      _iconButton(Lucide.chevronDown(), "More save actions"),
    ]),
    div([
      $class("button-group"),
      $("data-orientation")("vertical"),
      $role("group"),
      $aria.label("Zoom"),
      button([$class("btn"), $("data-variant")("outline"), "100%".t]),
      button([$class("btn"), $("data-variant")("outline"), $aria.label("Zoom in"), Lucide.plus()]),
      button([$class("btn"), $("data-variant")("outline"), $aria.label("Zoom out"), Lucide.minus()]),
    ]),
  ]),
]);

HTML _iconButton(HTML icon, String label) => button([$type("button"), $class("btn"), $("data-variant")("outline"), $("data-size")("icon"), $aria.label(label), icon]);

HTML _cardSection() => _showcase("card", "Card", "Full composition, dense size, media, and partial structures.", [
  div([
    $class("grid items-start gap-5 xl:grid-cols-3"),
    div([
      $class("card"),
      tags.header([
        h2(["Deploy application".t]),
        p(["Push the current release to production.".t]),
        menu([$class("card-action"), _iconButton(Lucide.ellipsis(), "More")]),
      ]),
      section([
        p([$class("text-sm"), "All checks passed. Version 1.8.0 is ready for deployment.".t]),
      ]),
      footer([
        button([$class("btn"), "Deploy now".t]),
        button([$class("btn"), $("data-variant")("outline"), "Review".t]),
      ]),
    ]),
    div([
      $class("card"),
      $("data-size")("sm"),
      tags.header([
        h2(["Dense card".t]),
        p(["Reduced spacing for compact interfaces.".t]),
      ]),
      section(["This card uses data-size=sm.".p()]),
      footer([
        span([$class("badge"), $("data-variant")("secondary"), "Compact".t]),
      ]),
    ]),
    div([
      $class("card"),
      section([
        div([
          $class("grid aspect-video place-items-center rounded-md bg-muted"),
          Lucide.image([$class("size-8 text-muted-foreground")]),
        ]),
      ]),
      tags.header([
        h2(["Media card".t]),
        p(["Cards can include rich visual content.".t]),
      ]),
    ]),
    div([
      $class("card"),
      section(["Content only".t]),
    ]),
    div([
      $class("card"),
      tags.header([
        h2(["Header only".t]),
        p(["Description without content.".t]),
      ]),
    ]),
    div([
      $class("card"),
      footer(["Footer only".t]),
    ]),
  ]),
]);

HTML _checkboxSection() => _showcase("checkbox", "Checkbox", "Checked, unchecked, disabled, invalid, and rich choice cards.", [
  div([
    $class("grid gap-5 md:grid-cols-2"),
    _checkField("check-default", "Email updates"),
    _checkField("check-checked", "Product announcements", checked: true),
    _checkField("check-disabled", "Disabled option", disabled: true),
    _checkField("check-invalid", "Required agreement", invalid: true),
    label([
      $class("field rounded-lg border p-4"),
      $("data-orientation")("horizontal"),
      input([$type("checkbox"), $class("input"), $checked("")]),
      section([
        span([$class("label"), "Automatic backups".t]),
        p(["Keep the last seven daily snapshots.".t]),
      ]),
    ]),
  ]),
]);

HTML _checkField(String id, String text, {bool checked = false, bool disabled = false, bool invalid = false}) => div([
  $class("field"),
  $role("group"),
  $("data-orientation")("horizontal"),
  if (disabled) $("data-disabled")(""),
  if (invalid) $("data-invalid")(""),
  input([$id(id), $type("checkbox"), $class("input"), $aria.describedby("$id-description"), if (checked) $checked(""), if (disabled) $disabled(""), if (invalid) $aria.invalid("true")]),
  section([
    label([$for(id), text.t]),
    p([$id("$id-description"), if (invalid) $role("alert"), (invalid ? "This option must be accepted." : "Control helper text.").t]),
  ]),
]);

List<bc_select.SelectItem> get _frameworks => [
  const bc_select.SelectItem(value: "dart", label: "Dart"),
  const bc_select.SelectItem(value: "go", label: "Go"),
  const bc_select.SelectItem(value: "rust", label: "Rust"),
  const bc_select.SelectItem(type: bc_select.SelectItemType.separator),
  const bc_select.SelectItem(value: "typescript", label: "TypeScript"),
  bc_select.SelectItem(value: "disabled", label: "Disabled", attrs: [$aria.disabled("true")]),
];

List<bc_select.SelectItem> get _groupedFrameworks => [
  const bc_select.SelectItem(
    type: bc_select.SelectItemType.group,
    label: "Backend",
    items: [
      bc_select.SelectItem(value: "dart", label: "Dart"),
      bc_select.SelectItem(value: "go", label: "Go"),
      bc_select.SelectItem(value: "rust", label: "Rust"),
    ],
  ),
  const bc_select.SelectItem(type: bc_select.SelectItemType.separator),
  const bc_select.SelectItem(
    type: bc_select.SelectItemType.group,
    label: "Frontend",
    items: [
      bc_select.SelectItem(value: "typescript", label: "TypeScript"),
      bc_select.SelectItem(value: "html", label: "HTML"),
    ],
  ),
];

HTML _comboboxSection() => _showcase("combobox", "Combobox", "Single, clearable, multiple, selected, and auto-highlight modes.", [
  div([
    $class("grid gap-4 sm:grid-cols-2 xl:grid-cols-3"),
    bc_combobox.combobox(id: "ui-combobox-basic", name: "language", items: _frameworks, placeholder: "Choose a language"),
    bc_combobox.combobox(id: "ui-combobox-clear", selected: "dart", items: _frameworks, placeholder: "Search languages", clear: true),
    bc_combobox.combobox(id: "ui-combobox-multiple", selected: ["dart", "go"], items: _frameworks, placeholder: "Choose several", multiple: true, autoHighlight: true),
  ]),
]);

List<bc_command.CommandItem> get _commandItems => [
  bc_command.CommandItem(
    type: bc_command.CommandItemType.group,
    label: "Suggestions",
    items: [
      bc_command.CommandItem(label: "Calendar", icon: Lucide.calendar(), shortcut: "⌘K"),
      bc_command.CommandItem(label: "Search files", icon: Lucide.search(), keywords: "find docs", shortcut: "⌘P"),
    ],
  ),
  const bc_command.CommandItem(type: bc_command.CommandItemType.separator),
  bc_command.CommandItem(
    type: bc_command.CommandItemType.group,
    label: "Settings",
    items: [
      bc_command.CommandItem(label: "Profile", icon: Lucide.user()),
      bc_command.CommandItem(label: "Billing", icon: Lucide.creditCard()),
    ],
  ),
];

HTML _commandSection() => _showcase("command", "Command", "Standalone filtering and native command dialog.", [
  div([
    $class("grid gap-5 lg:grid-cols-2"),
    bc_command.command(id: "ui-command", items: _commandItems, mainExtraClasses: "rounded-lg border"),
    div([
      $class("grid place-items-center rounded-lg border bg-muted/30 p-8"),
      button([
        $class("btn"),
        $("data-variant")("outline"),
        $("onclick")("document.getElementById('ui-command-dialog').showModal()"),
        Lucide.command([$("data-icon")("inline-start")]),
        "Open command menu".t,
      ]),
      bc_command.commandDialog(id: "ui-command-dialog", items: _commandItems),
    ]),
  ]),
]);

HTML _dialogSection() => _showcase("dialog", "Dialog", "Standard and compact-width compositions, including a surface without an implicit close button.", [
  div([
    $class("flex flex-wrap gap-3"),
    bc_dialog.dialog(
      id: "ui-dialog",
      trigger: "Open dialog",
      triggerAttrs: [$class("btn")],
      title: "Edit profile",
      description: "Update your public profile details.",
      body: _dialogForm(),
      footer: div([
        $class("flex justify-end gap-2"),
        button([$class("btn"), $("data-variant")("outline"), $("onclick")("this.closest('dialog').close()"), "Cancel".t]),
        button([$class("btn"), $("onclick")("this.closest('dialog').close()"), "Save".t]),
      ]),
    ),
    bc_dialog.dialog(
      id: "ui-dialog-sm",
      trigger: "Compact dialog",
      triggerAttrs: [$class("btn"), $("data-variant")("outline")],
      title: "Quick note",
      body: textarea([$class("textarea"), $aria.label("Quick note"), $placeholder("Write a note...")]),
      contentExtraClasses: "max-w-sm",
      closeButton: false,
    ),
  ]),
]);

HTML _dialogForm() => div([
  $class("field"),
  label([$for("dialog-name"), "Display name".t]),
  input([$id("dialog-name"), $class("input"), $value("Gustavo")]),
]);

HTML _dropdownSection() => _showcase("dropdown-menu", "Dropdown Menu", "Groups, icons, shortcuts, separators, disabled, and destructive items.", [
  bc_dropdown.dropdownMenu(
    id: "ui-dropdown",
    trigger: HTML.fragment(["Open menu".t, Lucide.chevronDown()]),
    triggerExtraClasses: "btn",
    popoverAttrs: [$("data-side")("bottom"), $("data-align")("start")],
    items: [
      bc_dropdown.DropdownMenuItem(
        type: bc_dropdown.DropdownMenuItemType.group,
        label: "Account",
        items: [
          bc_dropdown.DropdownMenuItem(label: "Profile", icon: Lucide.user()),
          bc_dropdown.DropdownMenuItem(label: "Billing", icon: Lucide.creditCard()),
        ],
      ),
      const bc_dropdown.DropdownMenuItem(type: bc_dropdown.DropdownMenuItemType.separator),
      bc_dropdown.DropdownMenuItem(label: "Disabled", icon: Lucide.ban(), attrs: [$aria.disabled("true")]),
      bc_dropdown.DropdownMenuItem(label: "Delete account", icon: Lucide.trash2(), attrs: [$("data-variant")("destructive")]),
    ],
  ),
]);

HTML _emptySection() => _showcase("empty", "Empty", "Icon, avatar, action, bordered, and muted empty states.", [
  div([
    $class("grid gap-5 lg:grid-cols-2"),
    section([
      $class("empty rounded-lg border border-dashed"),
      tags.header([
        figure([Lucide.inbox()]),
        h2(["No messages".t]),
        p(["New conversations will appear here.".t]),
      ]),
      footer([
        button([
          $class("btn"),
          Lucide.plus([$("data-icon")("inline-start")]),
          "New message".t,
        ]),
      ]),
    ]),
    section([
      $class("empty bg-muted/40"),
      tags.header([
        figure([_avatar("lg", "GS")]),
        h2(["Invite your team".t]),
        p(["Collaboration works better with company.".t]),
      ]),
      footer([
        button([$class("btn"), $("data-variant")("outline"), "Copy invite link".t]),
      ]),
    ]),
  ]),
]);

HTML _fieldSection() => _showcase("field", "Field", "Vertical, horizontal, responsive, invalid, disabled, and grouped controls.", [
  fieldset([
    $class("fieldset max-w-2xl"),
    legend(["Account details".t]),
    p(["Fields provide consistent labels, controls, help, and errors.".t]),
    div([
      $class("field"),
      $role("group"),
      label([$for("field-email"), "Email".t]),
      input([$id("field-email"), $type("email"), $placeholder("you@example.com"), $aria.describedby("field-email-description")]),
      p([$id("field-email-description"), "Used for account notifications.".t]),
    ]),
    div([
      $class("field"),
      $role("group"),
      $("data-orientation")("horizontal"),
      label([$for("field-timezone"), "Timezone".t]),
      input([$id("field-timezone"), $value("Europe/Rome")]),
    ]),
    div([
      $class("field"),
      $("data-orientation")("responsive"),
      label([$for("field-handle"), "Handle".t]),
      input([$id("field-handle"), $value("gustavo")]),
    ]),
    div([
      $class("field"),
      $("data-invalid")(""),
      label([$for("field-invalid"), "Project slug".t]),
      input([$id("field-invalid"), $aria.invalid("true"), $aria.describedby("field-error"), $value("Invalid slug!")]),
      p([$id("field-error"), $role("alert"), "Use lowercase letters and dashes only.".t]),
    ]),
    div([
      $class("field"),
      $("data-disabled")(""),
      label([$for("field-disabled"), "Workspace".t]),
      input([$id("field-disabled"), $disabled(""), $value("Default")]),
    ]),
  ]),
]);

HTML _inputSection() => _showcase("input", "Input", "Text, email, password, number, date, file, disabled, and invalid inputs.", [
  div([
    $class("grid gap-4 sm:grid-cols-2 lg:grid-cols-3"),
    for (final item in [("text", "Text"), ("email", "Email"), ("password", "Password"), ("number", "Number"), ("date", "Date"), ("file", "File")])
      div([
        $class("field"),
        label([$for("input-${item.$1}"), item.$2.t]),
        input([$id("input-${item.$1}"), $class("input"), $type(item.$1), if (item.$1 != "file") $placeholder("${item.$2} input")]),
      ]),
    input([$class("input"), $disabled(""), $placeholder("Disabled")]),
    input([$class("input"), $aria.label("Invalid example"), $aria.invalid("true"), $value("Invalid value")]),
  ]),
]);

HTML _inputGroupSection() => _showcase("input-group", "Input Group", "Prefixes, suffixes, actions, textarea, and vertical composition.", [
  div([
    $class("grid gap-5 lg:grid-cols-2"),
    div([
      $class("input-group"),
      span([$("data-align")("start"), "https://".t]),
      input([$type("text"), $placeholder("example.com")]),
    ]),
    div([
      $class("input-group"),
      input([$type("search"), $placeholder("Search documentation")]),
      span([$("data-align")("end"), Lucide.search()]),
    ]),
    div([
      $class("input-group"),
      span([$("data-align")("start"), "€".t]),
      input([$type("number"), $aria.label("Amount"), $value("1200")]),
      span([$("data-align")("end"), "EUR".t]),
    ]),
    div([
      $class("input-group"),
      input([$type("password"), $aria.label("Password"), $value("password")]),
      button([$type("button"), $("data-align")("end"), $aria.label("Show password"), Lucide.eye()]),
    ]),
    div([
      $class("input-group"),
      $("data-orientation")("vertical"),
      tags.header([$("data-align")("start"), "Message".t]),
      textarea([$placeholder("Write something...")]),
      footer([
        $("data-align")("end"),
        span(["0 / 240".t]),
      ]),
    ]),
  ]),
]);

HTML _itemSection() => _showcase("item", "Item", "Default, outlined, muted, compact, linked, grouped, and aside content.", [
  div([
    $class("item-group grid gap-3"),
    $role("list"),
    _item("Default item", "A flexible row for settings and lists.", Lucide.settings()),
    _item("Outlined item", "Carries its own visible boundary.", Lucide.box(), variant: "outline"),
    _item("Muted compact item", "Dense secondary information.", Lucide.info(), variant: "muted", size: "sm"),
    a([
      $href("#item"),
      $class("item"),
      $("data-variant")("outline"),
      figure([Lucide.externalLink()]),
      section([
        h3(["Linked item".t]),
        p(["The entire row is navigable.".t]),
      ]),
      aside([
        span([$class("badge"), "Open".t]),
      ]),
    ]),
  ]),
]);

HTML _item(String title, String text, HTML icon, {String? variant, String? size}) => article([
  $class("item"),
  $role("listitem"),
  if (variant != null) $("data-variant")(variant),
  if (size != null) $("data-size")(size),
  figure([icon]),
  section([
    h3([title.t]),
    p([text.t]),
  ]),
  aside([
    button([$class("btn"), $("data-variant")("ghost"), $("data-size")("icon-sm"), $aria.label("More"), Lucide.ellipsis()]),
  ]),
]);

HTML _kbdSection() => _showcase("kbd", "Kbd", "Single keys, shortcuts, and inline command hints.", [
  div([
    $class("flex flex-wrap items-center gap-5"),
    kbd([$class("kbd"), "Esc".t]),
    span([
      $class("inline-flex items-center gap-1"),
      kbd([$class("kbd"), "⌘".t]),
      kbd([$class("kbd"), "K".t]),
    ]),
    button([
      $class("btn"),
      $("data-variant")("outline"),
      "Open search".t,
      kbd([$class("kbd"), $("data-icon")("inline-end"), "/".t]),
    ]),
  ]),
]);

HTML _labelSection() => _showcase("label", "Label", "Associated, wrapping, required, and disabled labels.", [
  div([
    $class("grid max-w-2xl gap-5 sm:grid-cols-2"),
    div([
      label([$class("label"), $for("label-input"), "Associated label".t]),
      input([$id("label-input"), $class("input"), $placeholder("Input")]),
    ]),
    label([
      $class("label grid gap-2"),
      "Wrapping label".t,
      input([$class("input"), $placeholder("Nested input")]),
    ]),
    label([
      $class("label"),
      $for("label-required"),
      "Required field".t,
      span([$aria.hidden("true"), " *".t]),
    ]),
    input([$id("label-required"), $class("input"), $required(""), $placeholder("Required")]),
    label([$class("label opacity-50"), $for("label-disabled"), "Disabled label".t]),
    input([$id("label-disabled"), $class("input"), $disabled(""), $placeholder("Disabled")]),
  ]),
]);

HTML _nativeSelectSection() => _showcase("native-select", "Native Select", "Default, small, grouped, disabled, and invalid native controls.", [
  div([
    $class("grid gap-4 sm:grid-cols-2 lg:grid-cols-4"),
    _nativeSelect("Default", null),
    _nativeSelect("Small", "sm"),
    tags.select([
      $class("select"),
      $aria.label("Grouped technologies"),
      optgroup([
        $label("Backend"),
        option(["Dart".t]),
        option(["Go".t]),
      ]),
      optgroup([
        $label("Frontend"),
        option(["HTML".t]),
        option(["CSS".t]),
      ]),
    ]),
    tags.select([
      $class("select"),
      $aria.label("Disabled native select"),
      $disabled(""),
      option(["Disabled".t]),
    ]),
    tags.select([
      $class("select"),
      $aria.label("Invalid native select"),
      $aria.invalid("true"),
      option(["Invalid".t]),
    ]),
  ]),
]);

HTML _nativeSelect(String labelText, String? size) => tags.select([
  $class("select"),
  $aria.label("$labelText native select"),
  if (size != null) $("data-size")(size),
  option([labelText.t]),
  option(["Dart".t]),
  option(["Go".t]),
]);

HTML _paginationSection() => _showcase("pagination", "Pagination", "Previous, numbered, current, ellipsis, and next controls.", [
  nav([
    $aria.label("Pagination"),
    ul([
      $class("flex flex-wrap items-center gap-1"),
      li([
        a([
          $href("#pagination"),
          $class("btn"),
          $("data-variant")("ghost"),
          $("data-size")("sm"),
          Lucide.chevronLeft([$("data-icon")("inline-start")]),
          "Previous".t,
        ]),
      ]),
      for (var page = 1; page <= 3; page++)
        li([
          a([$href("#pagination"), $class("btn"), $("data-size")("icon"), $("data-variant")(page == 2 ? "outline" : "ghost"), if (page == 2) $aria.current("page"), page.toString().t]),
        ]),
      li([
        span([$class("grid size-9 place-items-center text-muted-foreground"), Lucide.ellipsis()]),
      ]),
      li([
        a([
          $href("#pagination"),
          $class("btn"),
          $("data-variant")("ghost"),
          $("data-size")("sm"),
          "Next".t,
          Lucide.chevronRight([$("data-icon")("inline-end")]),
        ]),
      ]),
    ]),
  ]),
]);

HTML _popoverSection() => _showcase("popover", "Popover", "Placement and alignment around composed content.", [
  div([
    $class("flex min-h-52 flex-wrap items-center justify-center gap-4"),
    for (final side in ["top", "bottom", "inline-start", "inline-end"])
      bc_popover.popover(
        id: "ui-popover-$side",
        trigger: "Open $side",
        triggerExtraClasses: "btn",
        triggerAttrs: [$("data-variant")("outline")],
        popoverAttrs: [$("data-side")(side), $("data-align")("center")],
        content: div([
          $class("w-64 space-y-2 p-1"),
          h3([$class("font-semibold"), "Popover content".t]),
          p([$class("text-sm text-muted-foreground"), "Inline content positioned on the $side side.".t]),
        ]),
      ),
  ]),
]);

HTML _progressSection() => _showcase("progress", "Progress", "Empty, partial, near-complete, and complete determinate states.", [
  div([
    $class("grid gap-5"),
    for (final value in [0, 28, 64, 100])
      div([
        div([
          $class("mb-2 flex justify-between text-sm"),
          span(["Upload".t]),
          span([$class("font-mono text-muted-foreground"), "$value%".t]),
        ]),
        div([
          $class("progress"),
          $role("progressbar"),
          $aria.label("Upload progress"),
          $("aria-valuenow")(value.toString()),
          $("aria-valuemin")("0"),
          $("aria-valuemax")("100"),
          span([$("style")("width: $value%")]),
        ]),
      ]),
  ]),
]);

HTML _radioSection() => _showcase("radio-group", "Radio Group", "Basic, selected, disabled, invalid, and rich-card radio choices.", [
  fieldset([
    $class("fieldset max-w-2xl"),
    $("data-slot")("radio-group"),
    legend(["Deployment region".t]),
    for (final region in [("eu", "Europe", true, false), ("us", "United States", false, false), ("ap", "Asia Pacific", false, true)])
      div([
        $class("field"),
        $role("group"),
        $("data-orientation")("horizontal"),
        if (region.$4) $("data-disabled")(""),
        input([$id("radio-${region.$1}"), $type("radio"), $class("input"), $name("region"), $value(region.$1), $aria.describedby("radio-${region.$1}-description"), if (region.$3) $checked(""), if (region.$4) $disabled("")]),
        section([
          label([$for("radio-${region.$1}"), region.$2.t]),
          p([$id("radio-${region.$1}-description"), "Deploy services in ${region.$2}.".t]),
        ]),
      ]),
    label([
      $class("field rounded-lg border p-4"),
      $("data-orientation")("horizontal"),
      input([$type("radio"), $class("input"), $name("region")]),
      section([
        span([$class("label"), "Custom region".t]),
        p(["Bring your own infrastructure.".t]),
      ]),
    ]),
    div([
      $class("field"),
      $role("group"),
      $("data-orientation")("horizontal"),
      $("data-invalid")(""),
      input([$id("radio-invalid"), $type("radio"), $class("input"), $name("invalid-region"), $aria.invalid("true"), $aria.describedby("radio-invalid-error")]),
      section([
        label([$for("radio-invalid"), "Invalid selection".t]),
        p([$id("radio-invalid-error"), $role("alert"), "Choose an available region.".t]),
      ]),
    ]),
  ]),
]);

HTML _selectSection() => _showcase("select", "Select", "Single, placeholder, grouped, disabled option, searchable, and multiple selection.", [
  div([
    $class("grid gap-4 sm:grid-cols-2 xl:grid-cols-3"),
    bc_select.select(id: "ui-select-basic", name: "runtime", selected: const ["dart"], items: _frameworks, placeholder: "Select runtime"),
    bc_select.select(id: "ui-select-placeholder", items: _groupedFrameworks, placeholder: "Grouped options"),
    bc_select.select(id: "ui-select-multiple", selected: const ["dart", "go"], items: _frameworks, multiple: true, closeOnSelect: true, placeholder: "Multiple"),
  ]),
]);

HTML _scrollAreaSection() => _showcase("scroll-area", "Scroll Area", "Native overflow with standard and compact scrollbar styling.", [
  div([
    $class("grid gap-5 md:grid-cols-2"),
    _scrollArea("scrollbar", 14),
    _scrollArea("scrollbar-sm", 14),
  ]),
]);

HTML _scrollArea(String style, int count) => div([
  $class("h-48 overflow-y-auto rounded-lg border p-3 $style"),
  for (var i = 1; i <= count; i++) div([$class("border-b px-2 py-2 text-sm last:border-0"), "Scrollable row $i".t]),
]);

HTML _sidebarSection() => _showcase("sidebar", "Sidebar", "This page uses the component index as a real Basecoat sidebar mounted next to the main content.", [
  div([
    $class("grid min-h-72 place-items-center rounded-lg border bg-muted/30 p-8 text-center"),
    div([
      $class("max-w-md"),
      div([
        Lucide.panelLeft([$class("mx-auto mb-3 size-7 text-muted-foreground")]),
        h3([$class("font-semibold"), "Component index sidebar".t]),
        p([$class("mt-2 text-sm text-muted-foreground"), "The left navigation uses Basecoat's sidebar component. The controls call its documented toggle API.".t]),
        div([$class("mt-5 flex justify-center"), _sidebarToggleButton()]),
      ]),
    ]),
  ]),
]);

HTML _skeletonSection() => _showcase("skeleton", "Skeleton", "Text, avatar, card, and table loading placeholders.", [
  div([
    $class("grid gap-8 md:grid-cols-2"),
    div([
      $class("flex items-center gap-4"),
      div([$class("skeleton size-12 rounded-full")]),
      div([
        $class("flex-1 space-y-2"),
        div([$class("skeleton h-4 w-2/3")]),
        div([$class("skeleton h-3 w-full")]),
        div([$class("skeleton h-3 w-4/5")]),
      ]),
    ]),
    div([
      $class("space-y-3 rounded-lg border p-4"),
      div([$class("skeleton aspect-video w-full rounded-md")]),
      div([$class("skeleton h-5 w-1/2")]),
      div([$class("skeleton h-4 w-full")]),
    ]),
    div([
      $class("space-y-2 md:col-span-2"),
      for (var i = 0; i < 4; i++)
        div([
          $class("grid grid-cols-4 gap-3"),
          for (var j = 0; j < 4; j++) div([$class("skeleton h-8")]),
        ]),
    ]),
  ]),
]);

HTML _sliderSection() => _showcase("slider", "Slider", "Default, stepped, disabled, and boundary values.", [
  div([
    $class("grid gap-6 md:grid-cols-2"),
    _slider("Volume", "35", "1", false),
    _slider("Stepped", "50", "10", false),
    _slider("Minimum", "0", "1", false),
    _slider("Disabled", "70", "1", true),
  ]),
]);

HTML _slider(String labelText, String value, String step, bool disabled) {
  final id = "slider-${labelText.toLowerCase().replaceAll(" ", "-")}";
  return div([
    $class("field"),
    label([$for(id), labelText.t]),
    input([$id(id), $type("range"), $class("input"), $min("0"), $max("100"), $("step")(step), $value(value), if (disabled) $disabled("")]),
  ]);
}

HTML _spinnerSection() => _showcase("spinner", "Spinner", "Lucide-based indicators at several sizes and inside composed controls.", [
  div([
    $class("flex flex-wrap items-center gap-6"),
    for (final size in ["size-4", "size-6", "size-8", "size-12"]) Lucide.loaderCircle([$class("$size animate-spin"), $role("status"), $aria.label("Loading")]),
    button([
      $class("btn"),
      $disabled(""),
      Lucide.loaderCircle([$class("animate-spin"), $("data-icon")("inline-start")]),
      "Saving".t,
    ]),
    span([
      $class("badge"),
      $("data-variant")("secondary"),
      Lucide.loaderCircle([$class("animate-spin"), $("data-icon")("inline-start")]),
      "Syncing".t,
    ]),
  ]),
]);

HTML _switchSection() => _showcase("switch", "Switch", "Default, small, checked, disabled, invalid, and descriptive switches.", [
  div([
    $class("grid gap-5 md:grid-cols-2"),
    _switch("switch-default", "Notifications"),
    _switch("switch-checked", "Dark analytics", checked: true),
    _switch("switch-small", "Compact switch", small: true, checked: true),
    _switch("switch-disabled", "Disabled", disabled: true),
    _switch("switch-invalid", "Required setting", invalid: true),
  ]),
]);

HTML _switch(String id, String title, {bool checked = false, bool small = false, bool disabled = false, bool invalid = false}) => div([
  $class("field"),
  $role("group"),
  $("data-orientation")("horizontal"),
  if (disabled) $("data-disabled")(""),
  if (invalid) $("data-invalid")(""),
  input([$id(id), $type("checkbox"), $role("switch"), $class("input"), $aria.describedby("$id-description"), if (small) $("data-size")("sm"), if (checked) $checked(""), if (disabled) $disabled(""), if (invalid) $aria.invalid("true")]),
  section([
    label([$for(id), title.t]),
    p([$id("$id-description"), if (invalid) $role("alert"), "Toggle this setting at any time.".t]),
  ]),
]);

HTML _tableSection() => _showcase("table", "Table", "Semantic headers, numeric alignment, status badges, and horizontal overflow.", [
  div([
    $class("table-container"),
    table([
      $class("table"),
      thead([
        tr([
          th(["Invoice".t]),
          th(["Status".t]),
          th(["Method".t]),
          th([$class("text-right"), "Amount".t]),
        ]),
      ]),
      tbody([
        for (final row in [("INV-001", "Paid", "Card", "€250.00"), ("INV-002", "Pending", "Transfer", "€125.00"), ("INV-003", "Failed", "Card", "€480.00")])
          tr([
            td([$class("font-mono"), row.$1.t]),
            td([
              span([
                $class("badge"),
                $("data-variant")(
                  row.$2 == "Paid"
                      ? "secondary"
                      : row.$2 == "Failed"
                      ? "destructive"
                      : "outline",
                ),
                row.$2.t,
              ]),
            ]),
            td([row.$3.t]),
            td([$class("text-right tabular-nums"), row.$4.t]),
          ]),
      ]),
      tfoot([
        tr([
          td([$("colspan")("3"), "Total".t]),
          td([$class("text-right font-semibold"), "€855.00".t]),
        ]),
      ]),
    ]),
  ]),
]);

HTML _tabsSection() => _showcase("tabs", "Tabs", "Default, line, vertical, selected, and disabled tabs.", [
  div([
    $class("grid gap-8"),
    bc_tabs.tabs(
      id: "ui-tabs",
      mainExtraClasses: "w-full max-w-2xl",
      tablistExtraClasses: "w-full",
      tabsets: [
        bc_tabs.Tabset(tab: "Account", panel: _accountTabsCard()),
        bc_tabs.Tabset(tab: "Password", panel: _passwordTabsCard()),
      ],
    ),
    div(
      [
        $class("grid gap-8 xl:grid-cols-2"),
        bc_tabs.tabs(
          id: "ui-tabs-line",
          mainExtraClasses: "w-full",
          tablistAttrs: [$aria.orientation("horizontal"), $("data-variant")("line")],
          tabsets: const [
            bc_tabs.Tabset(tab: "Overview", panel: "Overview content."),
            bc_tabs.Tabset(tab: "Analytics", panel: "Analytics content."),
            bc_tabs.Tabset(tab: "Reports", panel: "Reports content."),
          ],
        ),
        bc_tabs.tabs(
          id: "ui-tabs-vertical",
          defaultTabIndex: 2,
          mainExtraClasses: "grid grid-cols-[auto_1fr] gap-5",
          tablistAttrs: [$aria.orientation("vertical")],
          tabsets: [
            bc_tabs.Tabset(tab: "Account", panel: _smallTabPanel("Account content.")),
            bc_tabs.Tabset(tab: "Password", panel: _smallTabPanel("Password content.")),
            bc_tabs.Tabset(tab: "Disabled", panel: _smallTabPanel("Disabled content."), tabAttrs: [$disabled("")]),
          ],
        ),
        bc_tabs.tabs(
          id: "ui-tabs-icons",
          tabsets: [
            bc_tabs.Tabset(tab: HTML.fragment([Lucide.appWindow(), " Preview".t]), panel: _smallTabPanel("Preview content.")),
            bc_tabs.Tabset(tab: HTML.fragment([Lucide.code(), " Code".t]), panel: _smallTabPanel("Code content.")),
          ],
        ),
        bc_tabs.tabs(
          id: "ui-tabs-disabled",
          tabsets: [
            bc_tabs.Tabset(tab: "Home", panel: _smallTabPanel("Home content.")),
            bc_tabs.Tabset(tab: "Disabled", panel: _smallTabPanel("Settings content."), tabAttrs: [$disabled("")]),
          ],
        ),
      ],
    ),
  ]),
]);

HTML _accountTabsCard() => div([
  $class("card"),
  tags.header([
    h2(["Account".t]),
    p(["Make changes to your account here. Click save when you're done.".t]),
  ]),
  section([
    form([
      $class("grid gap-4"),
      div([
        $role("group"),
        $class("field"),
        label([$for("ui-tabs-account-name"), "Name".t]),
        input([$id("ui-tabs-account-name"), $type("text"), $value("Pedro Duarte")]),
      ]),
      div([
        $role("group"),
        $class("field"),
        label([$for("ui-tabs-account-username"), "Username".t]),
        input([$id("ui-tabs-account-username"), $type("text"), $value("@peduarte")]),
      ]),
    ]),
  ]),
  footer([
    button([$type("button"), $class("btn"), "Save changes".t]),
  ]),
]);

HTML _passwordTabsCard() => div([
  $class("card"),
  tags.header([
    h2(["Password".t]),
    p(["Change your password here. After saving, you'll be logged out.".t]),
  ]),
  section([
    form([
      $class("grid gap-4"),
      div([
        $role("group"),
        $class("field"),
        label([$for("ui-tabs-password-current"), "Current password".t]),
        input([$id("ui-tabs-password-current"), $type("password")]),
      ]),
      div([
        $role("group"),
        $class("field"),
        label([$for("ui-tabs-password-new"), "New password".t]),
        input([$id("ui-tabs-password-new"), $type("password")]),
      ]),
    ]),
  ]),
  footer([
    button([$type("button"), $class("btn"), "Save password".t]),
  ]),
]);

HTML _smallTabPanel(String text) => div([$class("rounded-lg border bg-muted/30 p-4 text-sm"), text.t]);

HTML _textareaSection() => _showcase("textarea", "Textarea", "Default, fixed-height, disabled, invalid, and field-integrated textareas.", [
  div([
    $class("grid gap-5 md:grid-cols-2"),
    textarea([$class("textarea"), $placeholder("Write a message...")]),
    textarea([$class("textarea min-h-32"), $placeholder("Long-form content")]),
    textarea([$class("textarea"), $disabled(""), "Disabled content".t]),
    textarea([$class("textarea"), $aria.label("Invalid textarea example"), $aria.invalid("true"), "Invalid content".t]),
    div([
      $class("field md:col-span-2"),
      $role("group"),
      label([$for("textarea-bio"), "Biography".t]),
      textarea([$id("textarea-bio"), $placeholder("Tell us about yourself"), $aria.describedby("textarea-bio-description")]),
      p([$id("textarea-bio-description"), "Maximum 500 characters.".t]),
    ]),
  ]),
]);

HTML _themeSection() => _showcase("theme-switcher", "Theme Switcher", "Theme API composed with standard icon buttons.", [
  div([
    $class("flex flex-wrap items-center gap-3"),
    button([
      $class("btn"),
      $("onclick")("window.basecoat.theme.set('light')"),
      Lucide.sun([$("data-icon")("inline-start")]),
      "Light".t,
    ]),
    button([
      $class("btn"),
      $("data-variant")("secondary"),
      $("onclick")("window.basecoat.theme.set('dark')"),
      Lucide.moon([$("data-icon")("inline-start")]),
      "Dark".t,
    ]),
    button([
      $class("btn"),
      $("data-variant")("outline"),
      $("onclick")("window.basecoat.theme.toggle()"),
      Lucide.sunMoon([$("data-icon")("inline-start")]),
      "Toggle".t,
    ]),
  ]),
]);

HTML _toastSection() => _showcase("toast", "Toast", "Success, info, warning, error, action, persistent, and close-all examples.", [
  div([
    $class("flex flex-wrap gap-3"),
    for (final type in bc_toast.ToastType.values) button([$class("btn"), $("data-variant")(type == bc_toast.ToastType.error ? "destructive" : "outline"), $("onclick")(_toastScript(type.name)), "${type.name[0].toUpperCase()}${type.name.substring(1)}".t]),
    button([$class("btn"), $("data-variant")("outline"), $("onclick")(_toastScript("info", persistent: true)), "Persistent".t]),
    button([$class("btn"), $("data-variant")("ghost"), $("onclick")("document.getElementById('toaster').closeAll()"), "Close all".t]),
  ]),
]);

String _toastScript(String category, {bool persistent = false}) =>
    "document.getElementById('toaster').toast({category: '$category', ${persistent ? "duration: -1," : ""} title: '${category[0].toUpperCase()}${category.substring(1)} toast', description: 'This notification was created by the Basecoat toast API.', action: {label: 'Undo', onclick: () => true}})";

HTML _tooltipSection() => _showcase("tooltip", "Tooltip", "Every side, alignment, keyboard focus, and disabled-control wrapper.", [
  div([
    $class("flex min-h-32 flex-wrap items-center justify-center gap-4"),
    for (final side in ["top", "right", "bottom", "left", "inline-start", "inline-end"]) button([$class("btn"), $("data-variant")("outline"), $("data-tooltip")("Tooltip on $side"), $("data-side")(side), side.t]),
    span([
      $("data-tooltip")("Disabled controls need a wrapper"),
      $("data-side")("bottom"),
      button([$class("btn"), $disabled(""), "Disabled".t]),
    ]),
  ]),
]);
