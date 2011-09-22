/*
BUILD WITH:
valac --thread --pkg libsoup-2.4 --pkg json-glib-1.0 --pkg gee-1.0 main.vala data.vala -o dtt


Copyright 2011 Scotty Delicious <scottydelicious@gmail.com>

This file is part of Daily TV Torrents.

Daily TV Torrents is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

Daily TV Torrents is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
License for more details.

You should have received a copy of the GNU General Public License 
along with Daily TV Torrents. If not, see http://www.gnu.org/licenses/.
*/

using Gee;

class DTT.Main : GLib.Object {

	struct Globals {
		
		static string[] args;
		static bool version;
		static bool torrent;
		static bool episode;
		static bool show;
		static bool info;
		static bool colors;
		static bool links;
		static bool get_new;
		static string search;

		public static const OptionEntry[] options = {
			{"version", 'v', 0, OptionArg.NONE, ref Globals.version, "print the version number", null},
			{"torrent", 'T', 0, OptionArg.NONE, ref Globals.torrent, "Get torrent info", null},
			{"episode", 'E', 0, OptionArg.NONE, ref Globals.episode, "Get episode info", null},
			{"show", 'S', 0, OptionArg.NONE, ref Globals.show, "Get show info", null},
			{"info", 'i', 0, OptionArg.NONE, ref Globals.info, "Pass the 'info' flag", null},
			{"colors", 'c', 0, OptionArg.NONE, ref Globals.colors, "Get full color text", null},
			{"links", 'l', 0, OptionArg.NONE, ref Globals.links, "Get links with the text info", null},
			{"get-new", 0, 0, OptionArg.NONE, ref Globals.get_new, "Returns the show objects of new series.", null},
			{"search", 's', 0, OptionArg.STRING, ref Globals.search, "Search remotely", "\"American\""},
			{null}
		};

	}

	private static const string VERSION = "Daily TV Torrents CLI\nversion 0.1.0\n";
	private static string data_response;

	public static int main (string[] args) {
		DTT.Data dtt = new DTT.Data ();
		OptionContext context = new OptionContext ("tv_show_name");
		Globals.show = true;
		context.add_main_entries (Globals.options, null);

		try {
			context.parse (ref args);
		}
		catch (Error e) {
			stderr.printf ("Error initializing: %s\n", e.message);
		}
		
		/*
		 * Start Parsing the parameters
		 */
		if (Globals.version) {
			stdout.printf("%s",VERSION);
			return 0;
		}
		if (Globals.torrent) {
			stdout.printf ("Using Torrent Functions\n");
		}

		if (Globals.episode) {
			HashMap<string,string> le = dtt.episode_get_latest (args[1]);
			string output = "\nTitle: %s\n";
			output += "Episode: %s\n";
			output += "Age %s\n\n";
			output += "Links\n-------\n";
			output += "[HD]: %s\n";
			output += "[720]: %s\n";
			output += "[1080]: %s\n";
			stdout.printf(output, le["title"], le["number"], le["age"], le["hd"], le["720"], le["1080"]);

			return 0;
		}

		if (Globals.show) {
			
			if (Globals.info) {
				// Info
				return 0;
			}
			
			if (Globals.get_new) {
				// Get new
				return 0;
			}
			
			dtt.optparams.colors = Globals.colors ? true : false;
			data_response = dtt.shows_get_text_info (args[1]);
			stdout.printf ("%s\n", data_response);

		}


		foreach (string a in args) {
			stdout.printf ("ARGUMENT: %s\n", a);
		}

		return 0;
	}

}
