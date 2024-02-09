/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Juan Pablo Lozano <lozanotux@gmail.com>
 */

public class MainWindow : Gtk.ApplicationWindow {

    public Gtk.FileChooserDialog file;
    public Gst.Element pipeline;
    public Gst.PbUtils.DiscovererInfo info;
    private GLib.MainLoop loop = new GLib.MainLoop ();

    private Gtk.HeaderBar controls;
    private InformationView info_view;
    private Gtk.ActionBar status_bar;

    private Gtk.Button backward_button;
    public Gtk.Button play_button;
    public Gtk.Button pause_button;
    private Gtk.Button forward_button;
    private Gtk.Button sequential_button;
    private Gtk.Button random_button;
    private Gtk.Button equalizer_button;

    private bool paused = false;
    private bool playing = false;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: Constants.APP_NAME,
            default_width: 320,
            default_height: 600,
            resizable: false
        );
    }

    construct {
        // Instantiate Settings var for store configs
		var settings = new Settings ("com.github.lozanotux.dribbble");

        // Main box to pack the rest of widgets
        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

        controls = new Gtk.HeaderBar ();
        /*
         * Create Buttons
         */
        //BACKWARD BUTTON
        backward_button = new Gtk.Button.from_icon_name ("media-seek-backward-symbolic");
        backward_button.tooltip_text = "Backward";

        // PLAY BUTTON
        play_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        play_button.tooltip_text = "Play Song";

        // PAUSE BUTTON
        pause_button = new Gtk.Button.from_icon_name ("media-playback-pause-symbolic");
        pause_button.tooltip_text = "Pause";

        //FORWARD BUTTON
        forward_button = new Gtk.Button.from_icon_name ("media-seek-forward-symbolic");
        forward_button.tooltip_text = "Forward";

        //SEQUENTIAL BUTTON
        sequential_button = new Gtk.Button.from_icon_name ("media-playlist-repeat-symbolic");
        sequential_button.tooltip_text = "Sequential";

        //RANDOM BUTTON
        random_button = new Gtk.Button.from_icon_name ("media-playlist-shuffle-symbolic");
        random_button.tooltip_text = "Random";

        //EQUALIZER BUTTON
        equalizer_button = new Gtk.Button.from_icon_name ("media-eq-symbolic");
        equalizer_button.tooltip_text = "Equalizer";

        /*
         * Add Buttons to a Container
         */
        var player_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        player_box.append (backward_button);
        player_box.append (play_button);
        player_box.append (forward_button);


        var equalizer_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        equalizer_box.append (equalizer_button);

        controls.set_title_widget (player_box);
        controls.pack_end (equalizer_box);
        controls.pack_end (random_button);
        controls.pack_end (sequential_button);

        info_view = new InformationView ();
        info_view.set_vexpand (true);
        info_view.add_css_class (Constants.INFORMATION_VIEW);

        status_bar = new Gtk.ActionBar ();
        status_bar.add_css_class (Constants.STATUS_BAR);
        
        //ADD BUTTON
        var add_button = new Gtk.Button.from_icon_name ("list-add-symbolic");
        add_button.tooltip_text = "Add Folder";
        add_button.add_css_class (Constants.STATUSBAR_ICON);
        
        //REMOVE BUTTON
        var rem_button = new Gtk.Button.from_icon_name ("list-remove-symbolic");
        rem_button.tooltip_text = "Remove Folder";
        rem_button.add_css_class (Constants.STATUSBAR_ICON);

        status_bar.pack_start (add_button);
        status_bar.pack_start (rem_button);

        controls.add_css_class (Constants.HEADER_BAR);
        set_titlebar (controls);
        add_css_class (Constants.MAIN_WINDOW);

        //PLAYER ------- TEST BETA ALPHA DEV
        //Accion para obtener la ruta de la nueva imagen
	    info_view.buscar.clicked.connect (() => {
		    file = new Gtk.FileChooserDialog (
                "Seleccionar una musica en formato MP3", 
                this,
                Gtk.FileChooserAction.OPEN,
                "_Close", Gtk.ResponseType.CLOSE,
                "_OK", Gtk.ResponseType.ACCEPT
            );

            file.present();
		    
            file.response.connect (on_response);
	    });

        play_button.clicked.connect (() => {
            // Change play button with pause button
            player_box.remove (play_button);
            player_box.insert_child_after (pause_button, backward_button);

            if ((paused) && (!playing)) {
                pipeline.set_state (Gst.State.PLAYING);
                paused = false;
                playing = true;
            } else {
                // Creating elements
                pipeline = Gst.ElementFactory.make ("playbin", "player");
                pipeline.set ("uri", info_view.path.get_text ());

                // Adding a callback for pipeline events
                var bus = pipeline.get_bus ();
                bus.add_watch (GLib.Priority.DEFAULT, on_bus_callback);

                // Set pipeline state to PLAYING
                pipeline.set_state (Gst.State.PLAYING);
                playing = true;

                // Print tags
                unowned Gst.TagList? tags = info.get_tags ();
                string artist_s;
                tags.get_string (Gst.Tags.ARTIST, out artist_s);
                string title_s;
                tags.get_string (Gst.Tags.TITLE, out title_s);
                info_view.title.set_markup ("<b>" + title_s + "</b>");
                info_view.artist.set_label (artist_s);

                string album_s;
                tags.get_string (Gst.Tags.ALBUM, out album_s);

                uint64 dur = info.get_duration ();
                int segundos = (int) (dur / 1000000000) % 60;
                int minutos = (int) (dur / 60000000000);

                info_view.total_time.set_label (minutos.to_string() + ":" + segundos.to_string());

                //  string img_s;
                //  tags.get_string (Gst.Tags.IMAGE, out img_s);
                //  message ("IMG_S: %s", img_s);
                //  uchar[] data_img = GLib.Base64.decode (img_s);
                
                // running main loop
                message ("Playing...");
                loop.run ();
            }
        });

        pause_button.clicked.connect (() => {
            pipeline.set_state (Gst.State.PAUSED);
            paused = true;
            playing = false;

            // Change play button with pause button
            player_box.remove (pause_button);
            player_box.insert_child_after (play_button, backward_button);
        });
        
        main_box.prepend (info_view);
        //FIN PLAYER ------ TEST BETA ALPHA DEV

        //main_box.pack_start (welcome_screen, true, true, 0);
        main_box.append (status_bar);
        main_box.set_size_request (320, 500);

        /************************************
         * SAVE APPLICATION SETTINGS IN GCONF
         ************************************/
        close_request.connect (() => {
            if ((playing) || (paused)) {
               pipeline.set_state (Gst.State.NULL);
            }
            Gst.deinit ();
            loop.quit ();

            return false;
		});
        
        set_child (main_box);
    }

    bool on_bus_callback (Gst.Bus bus, Gst.Message message) {
        switch (message.type) {
            case Gst.MessageType.ERROR:
                GLib.Error err;
                string debug;
                message.parse_error (out err, out debug);
                warning ("Error: %s", err.message);
                loop.quit ();
                break;
            case Gst.MessageType.EOS:
                warning ("End of stream");
                break;
            default:
                break;
        }
  
        return true;
    }

    private void on_response (Gtk.Dialog source, int response_id) {
        if (response_id == Gtk.ResponseType.ACCEPT) {
            // Obtiene el archivo en un puntero 'archivo'
            GLib.File archivo = file.get_file ();

            // Obtiene la ruta del archivo y la guarda en la variable path
            info_view.path.set_text (archivo.get_uri ());
            info = info_view.discover.discover_uri(archivo.get_uri ());
        }

        file.destroy ();
    }

}