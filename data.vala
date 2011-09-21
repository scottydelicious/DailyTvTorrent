/*
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

using Soup;
using Json;

class DTT.Data : GLib.Object {

	private const string base_url = "http://api.dailytvtorrents.org/1.0/";
	public Params optparams;

	public struct Params {
		public static string show_name;
		public static int page;
		public static string episode_num;
		public static string quality;
		public static string fallback; 
		public static int max_age_hours;
		public static int max_items;
		public static string sort; // age (newest first[default]) or score (highest first) 
		public static bool colors;
		public static string links;
	}

	public Data () {
		// Constructor
	}

	public void episode_get_latest (string show_name) {
		string method = "episode.getLatest";
		string url = "%s/%s?show_name=%s".printf(base_url, method, show_name);
		string data = query_remote (url);
		Json.Object root = json_root_object (data);
		stdout.printf ("Title: %s/n", root.get_string_member ("title") );
		stdout.printf ("Number: %s/n", root.get_string_member ("num") );
		stdout.printf ("Age: %i/n", (int) root.get_int_member ("age") );
		stdout.printf ("HD: %s/n", root.get_string_member ("hd") );
		stdout.printf ("720: %s/n", root.get_string_member ("720") );
		stdout.printf ("1080: %s/n", root.get_string_member ("1080") );
	}

	public string shows_get_text_info (string show_names) {
		string method = "shows.getTextInfo";
		string colors = optparams.colors ? "&colors=yes" : "";
		string url = "%s/%s?show_names=%s%s".printf(base_url, method, show_names, colors);

		return query_remote (url);
	}
	
	// Private Methods
	private string query_remote (string url) {
		var session = new Soup.SessionAsync();
		var message = new Soup.Message("GET", url);
		session.send_message(message);
		return (string) message.response_body.data;
	}

	private Json.Object json_root_object (string json_text) {
		var parser = new Json.Parser();

		try {
			parser.load_from_data (json_text);
		}
		catch (Error e) {
			stderr.printf ("[ERROR]: %s\n", e.message);
		}

		var root_object = parser.get_root().get_object();
		return root_object;
	}

}
