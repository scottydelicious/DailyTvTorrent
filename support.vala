/*
Copyright 2011 Scotty Delicious <scottydelicious@gmail.com>

This file is part of Daily TV Torrents.

Daily TV Torrents is free software: you can redistribute it and/or modify it 
under the terms of the GNU General License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

Daily TV Torrents is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
License for more details.

You should have received a copy of the GNU General License 
along with Daily TV Torrents. If not, see http://www.gnu.org/licenses/.
*/



/**
 * Classes
 */
class Age : Object {
	int days;
	int hours;
	int minutes;
	int seconds;

	public string to_string() {
		string a = "";
		a += this.days != 0 ? "%i days, ".printf(this.days) : "";
		a += this.hours != 0 ? "%i hours, ".printf(this.hours) : "";
		a += this.minutes != 0 ? "%i minutes and ".printf(this.minutes) : "";
		a += "%i seconds".printf(this.seconds);
		return a;
	}

	public Age (int64 seconds = 1) {

		this.seconds = (int) seconds % 60;
		this.minutes = (int) seconds /60;
		this.hours = this.minutes / 60;
		this.minutes %= 60;
		this.days = this.hours / 24;
		this.hours %= 24;

	}	
}


/**
 * Structs
 */
struct Options {
	static string show_name;
	int page;
	static string episode_num;
	static string quality;
	bool fallback; 
	int max_age_hours;
	int max_items;
	static string sort; // age (newest first[default]) or score (highest first) 
	bool colors;
	bool links;
}

struct LatestEpisode {
	static string title;
	static string number;
	Age age;
	static string hd;
	static string hd720;
	static string hd1080;
}

struct Show {
	static string name;
	static string pretty_name;
	static string genre;
	static string link;
	LatestEpisode latest_episode;
}
