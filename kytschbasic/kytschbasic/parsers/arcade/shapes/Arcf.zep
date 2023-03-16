/**
 * ARCF parser
 *
 * @package     KytschBASIC\Parsers\Arcade\Shapes\Arcf
 * @author 		Mike Welsh
 * @copyright   2022 Mike Welsh
 * @version     0.0.1
 *
 * Copyright 2022 Mike Welsh
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA  02110-1301, USA.
 */
namespace KytschBASIC\Parsers\Arcade\Shapes;

use KytschBASIC\Parsers\Arcade\Shapes\Shape;
use KytschBASIC\Parsers\Core\Args;
use KytschBASIC\Parsers\Core\Session;

class Arcf extends Shape
{
	protected static style = 0;

	public function copyShape(
		var image
	) {
		var colour = imagecolorallocatealpha(image, self::red, self::green, self::blue, self::transparency);
		imagefilledarc(image, self::x, self::y, self::radius, self::radius, self::start_angle, self::end_angle, colour, self::style);

		return image;
	}

	public static function draw(
		string command,
		var image,
		event_manager = null,
		array globals = []
	) {
		/*
		 * Styles
		 * IMG_ARC_PIE = 0
		 * IMG_ARC_CHORD = 1
		 * IMG_ARC_NOFILL = 2
		 * IMG_ARC_EDGED = 4
		 */
		var args, colour, rgb;
		let args = Args::parseShort("ARCF", command);

		if (isset(args[0])) {
			let self::x = intval(args[0]);
		}

		if (isset(args[1])) {
			let self::y = intval(args[1]);
		}

		if (isset(args[2])) {
			let self::start_angle = intval(args[2]);
		}

		if (isset(args[3])) {
			let self::end_angle = intval(args[3]);
		}

		if (isset(args[4])) {
			let self::radius = intval(args[4]);
		}

		if (isset(args[5])) {
			let self::style = intval(args[5]);
		}

		let rgb = Session::read("RGB#");

		if (rgb) {
			let self::red = intval(rgb[0]);
			let self::green = intval(rgb[1]);
			let self::blue = intval(rgb[2]);
			let self::transparency = Args::transparency(rgb[3]);
		}

		let colour = imagecolorallocatealpha(image, self::red, self::green, self::blue, self::transparency);
		imagefilledarc(image, self::x, self::y, self::radius, self::radius, self::start_angle, self::end_angle, colour, self::style);

		Session::addLastCreate(new self());

		return image;
	}

	public function getStyle()
	{
		return self::style;
	}
}
