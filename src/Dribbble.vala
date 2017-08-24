/*
* Copyright (c) 2011-2017 Dribbble
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Juan Pablo Lozano <lozanotux@gmail.com>
*/

using Gtk;
using GLib;
using Granite.Widgets;

public class Dribbble : Gtk.Application {

    public Dribbble () {
        Object (application_id: "com.github.lozanotux.dribbble",
                flags:          ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        var app_window = new Gtk.ApplicationWindow (this);
        app_window.set_default_size (320, 600);
        app_window.set_resizable (false);

        var main_box = new Box (Gtk.Orientation.VERTICAL, 0);

        var controls = new Controls ();
        var welcome_screen = new WelcomeView ();
        var status_bar = new StatusBar ();


        controls.get_style_context ().add_class("csd");
        app_window.set_titlebar (controls);
        app_window.get_style_context ().add_class("main_window");


        main_box.pack_start (welcome_screen, true, true, 0);
        main_box.pack_end (status_bar, false, true, 0);
        main_box.set_size_request (320, 500);

        app_window.add (main_box);
        app_window.show_all ();
    }

    public static int main (string[] args) {
        Gtk.init (ref args);//Initializes GTK+

        string css_file = "/usr/share/dribbble/stylesheet.css";//CSS file path
	    var css_provider = new Gtk.CssProvider ();//Create a new CSS Provider

	    try
	    {
		    css_provider.load_from_path (css_file);//Load the CSS file from the above path (string)
		    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);//Establece un contexto de estilo y la prioridad
	    } catch (Error e) {//Capturing Error
	  	    stderr.printf ("COM.DRIBBBLE.CORE: [ERROR LOADING CSS STYLES [%s]]\n", e.message);
	  	    stderr.printf (">>> Check path: /usr/share/dribbble/stylesheet.css\n");
	    }

        var app = new Dribbble ();
        return app.run (args);
    }
}
