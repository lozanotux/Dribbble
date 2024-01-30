/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Juan Pablo Lozano <lozanotux@gmail.com>
 */
 
 public class Dribbble : Gtk.Application {

    public MainWindow? main_window = null;

    public Dribbble () {
        Object (
            application_id: "com.github.lozanotux.dribbble",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        // Load CSS styles
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("com/github/lozanotux/dribbble/application.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        // Main Window
        main_window = new MainWindow (this);
        main_window.present ();
    }

    public static int main (string[] args) {
        // initializing GStreamer
        Gst.init (ref args);
        Gst.PbUtils.init();

        return new Dribbble ().run (args);
    }
}