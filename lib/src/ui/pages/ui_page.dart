import "package:absurd_starter/generated/html.dart";
import "package:absurd_starter/src/ui/basecoat/basecoat.dart" as bc;

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
  ("drawer", "Drawer"),
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
  ("scroll-area", "Scroll Area"),
  ("select", "Select"),
  ("separator", "Separator"),
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

/// Development-only gallery of the Basecoat docs examples.
Fragment uiPage() => Html.pages.ui(
  sidebar: bc.sidebar(
    id: "ui-sidebar",
    label: "Component index",
    header: "Components",
    headerAttrs: {"class": "px-2 font-semibold"},
    menu: [
      bc.Item(
        type: bc.ItemType.group,
        items: [for (final (id, label) in _components) bc.Item(label: label, url: "#$id")],
      ),
    ],
  ),
  toaster: bc.toaster(),
);

/// The toast returned by the HTMX example in the gallery.
Fragment uiToast() => bc.toast(
  title: "Success",
  description: "A success toast called from the backend.",
  cancel: const bc.ToastAction(label: "Dismiss"),
);
