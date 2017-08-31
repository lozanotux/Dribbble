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

public class Controls : HeaderBar {

    private ToolButton backward_button;
    public ToolButton play_button;
    private ToolButton forward_button;
    private Button sequential_button;
    private Button random_button;
    private Button equalizer_button;

    public Controls () {

        /*
         * Set Defaults
         */
        this.show_close_button = true;
        this.has_subtitle = true;        

        /*
         * Create Buttons
         */
        //BACKWARD BUTTON
        var back_img = new Image ();
        back_img.set_from_icon_name ("media-seek-backward-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        backward_button = new ToolButton (back_img, "Backward");
        backward_button.tooltip_text = "Backward";

        // PLAY BUTTON 
        var play_img = new Image ();
        play_img.set_from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        play_button = new ToolButton (play_img, "Playback");
        play_button.tooltip_text = "Play Song";

        //FORWARD BUTTON
        var fwd_img = new Image ();
        fwd_img.set_from_icon_name ("media-seek-forward-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        forward_button = new ToolButton (fwd_img, "Forward");
        forward_button.tooltip_text = "Forward";

        //SEQUENTIAL BUTTON
        var seq_img = new Image ();
        seq_img.set_from_icon_name ("media-playlist-repeat-symbolic", Gtk.IconSize.MENU);
        sequential_button = new Button ();
        sequential_button.set_image (seq_img);
        sequential_button.tooltip_text = "Sequential";

        //RANDOM BUTTON
        var ran_img = new Image ();
        ran_img.set_from_icon_name ("media-playlist-shuffle-symbolic", Gtk.IconSize.MENU);
        random_button = new Button ();
        random_button.set_image (ran_img);
        random_button.tooltip_text = "Random";

        //EQUALIZER BUTTON
        var equ_img = new Image ();
        equ_img.set_from_icon_name ("media-eq-symbolic", Gtk.IconSize.MENU);
        equalizer_button = new Button ();
        equalizer_button.set_image (equ_img);
        equalizer_button.tooltip_text = "Equalizer";

        /*
         * Add Buttons to a Container
         */
        var player_box = new Box (Gtk.Orientation.HORIZONTAL, 0);
        player_box.pack_start (backward_button, false, true, 0);
        player_box.pack_start (play_button, false, true, 0);
        player_box.pack_start (forward_button, false, true, 0);


        var equalizer_box = new Box (Gtk.Orientation.HORIZONTAL, 0);
        equalizer_box.pack_start (equalizer_button, false, true, 8);

        this.custom_title = player_box;
        this.pack_end (equalizer_box);
        this.pack_end (random_button);
        this.pack_end (sequential_button);
        this.show_all ();

    }

}
