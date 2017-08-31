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
using Gst;
using Granite.Widgets;

public class Dribbble : Gtk.Application {

    public GLib.Settings settings;
    public Element pipeline;
    public Gst.PbUtils.DiscovererInfo info;

    private MainLoop loop = new MainLoop ();

    bool on_bus_callback (Gst.Bus bus, Gst.Message message) {
      switch (message.type) {
        case Gst.MessageType.ERROR:
            GLib.Error err;
            string debug;
            message.parse_error (out err, out debug);
            stdout.printf ("Error: %s\n", err.message);
            loop.quit ();
            break;
        case Gst.MessageType.EOS:
            stdout.printf ("end of stream\n");
            break;
        default:
            break;
        }

        return true;
    }

    public Dribbble () {
        GLib.Object (application_id: "com.github.lozanotux.dribbble",
                              flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        // Instantiate Settings var for store configs
		settings = new GLib.Settings ("org.dribbble");

        var app_window = new Gtk.ApplicationWindow (this);
        app_window.set_default_size (320, 600);
        app_window.move (settings.get_int ("opening-x"), settings.get_int ("opening-y"));
        app_window.set_resizable (false);

        var main_box = new Box (Gtk.Orientation.VERTICAL, 0);

        var controls = new Controls ();
        //var welcome_screen = new WelcomeView ();
        var info_view = new InformationView ();
        var status_bar = new StatusBar ();

        controls.get_style_context ().add_class("csd");
        app_window.set_titlebar (controls);
        app_window.get_style_context ().add_class("main_window");

        //PLAYER ------- TEST BETA ALPHA DEV
        //Accion para obtener la ruta de la nueva imagen
	    info_view.buscar.clicked.connect (() => {
		    var file = new FileChooserDialog ("Seleccionar una musica en formato MP3", null, FileChooserAction.OPEN);
		    file.add_button (Stock.CLOSE, Gtk.ResponseType.CLOSE);
		    file.add_button (Stock.OK, Gtk.ResponseType.ACCEPT);
		    if (file.run () == ResponseType.ACCEPT)
		    {
			    File archi = file.get_file (); //obtiene el archivo en un puntero 'archi'
			    info_view.pat.set_text (archi.get_uri ()); //obtiene la ruta del archivo y la guarda en PAT
                info = info_view.discover.discover_uri(archi.get_uri ());
			    file.destroy ();
		    }
		    file.destroy ();
	    });

        controls.play_button.clicked.connect (() => {
            // creating elements
            pipeline  = ElementFactory.make ("playbin", "player");
            pipeline.set ("uri", info_view.pat.get_text ());

            // adding a callback for pipeline events
            var bus = pipeline.get_bus ();
            bus.add_watch (GLib.Priority.DEFAULT, on_bus_callback);

            // set pipeline state to PLAYING
            pipeline.set_state (State.PLAYING);

            // print tags
            unowned Gst.TagList? tags = info.get_tags ();
            string artist_s;
            tags.get_string (Gst.Tags.ARTIST, out artist_s);
            string title_s;
            tags.get_string (Gst.Tags.TITLE, out title_s);
            info_view.song.set_markup ("<b>" + artist_s + " - " + title_s + "</b>");

            string album_s;
            tags.get_string (Gst.Tags.ALBUM, out album_s);
            info_view.album.set_label (album_s);

            uint64 dur = info.get_duration ();
            int segundos = (int) (dur / 1000000000) % 60;
            int minutos = (int) (dur / 60000000000);

            info_view.total_time.set_label (minutos.to_string() + ":" + segundos.to_string());

            string img_s;
            tags.get_string (Gst.Tags.IMAGE, out img_s);
            uchar[] data_img = GLib.Base64.decode (img_s);
            
            // running main loop
            print ("\nRunning...\n");
            loop.run ();
        });
        
        main_box.pack_start (info_view, true, true, 0);
        //FIN PLAYER ------ TEST BETA ALPHA DEV

        //main_box.pack_start (welcome_screen, true, true, 0);
        main_box.pack_end (status_bar, false, true, 0);
        main_box.set_size_request (320, 500);

        /************************************
         * SAVE APPLICATION SETTINGS IN GCONF
         ************************************/
        app_window.delete_event.connect (() => {
    			int x, y;

    			app_window.get_position (out x, out y);//Get Current Window Position of Screen in X and Y vars

    			//Guardar Valores en GSCHEMA
				settings.set_int ("opening-x", x);
    			settings.set_int ("opening-y", y);

                pipeline.set_state (State.NULL);
                Gst.deinit ();
    
    			return false;
		});
        
        app_window.destroy.connect (Gtk.main_quit);
        app_window.add (main_box);
        app_window.show_all ();
    }

    public static int main (string[] args) {
        Gtk.init (ref args);//Initializes GTK+
        // initializing GStreamer
        Gst.init (ref args);
        Gst.PbUtils.init();

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
