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

	public DTT.Data () {
		// Constructor
	}

	private string query_remote (string url) {
		var session = new Soup.SessionAsync();
		var message = new Soup.Message("GET", url);
		session.send_message(message);
		return (string) message.response_body.data;
	}

	private Json.Object parse_json (string json_text) {
		var parser = new Json.Parser();
		parser.load_from_data (json_text);
		var root_object = parser.get_root().get_object();
		return root_object;
	}

}
