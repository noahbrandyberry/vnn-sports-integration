import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Import and register all TailwindCSS Components
import {
  Alert,
  Autosave,
  Dropdown,
  Modal,
  Tabs,
  Popover,
  Toggle,
  Slideover,
} from "tailwindcss-stimulus-components";
import Form from "./forms";

application.register("forms", Form);
application.register("alert", Alert);
application.register("autosave", Autosave);
application.register("dropdown", Dropdown);
application.register("modal", Modal);
application.register("tabs", Tabs);
application.register("popover", Popover);
application.register("toggle", Toggle);
application.register("slideover", Slideover);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
