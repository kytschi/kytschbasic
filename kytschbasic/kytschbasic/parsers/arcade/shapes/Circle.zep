/**
 * CIRCLE parser
 *
 * @package     KytschBASIC\Parsers\Arcade\Shapes\Circle
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

class Circle extends Shape
{
	public function copyShape(
		var image
	) {
		var colour = imagecolorallocatealpha(image, self::red, self::green, self::blue, self::transparency);
		imagearc(image, self::x, self::y, self::radius, self::radius,  0, 360, colour);

		return image;
	}

	public static function draw(
		string command,
		event_manager = null,
		array globals = [],
		var config = null
	) {
		var args;
		let args = Args::parseShort("CIRCLE", command);

		if (isset(args[0])) {
			let self::x = intval(args[0]);
		}

		if (isset(args[1])) {
			let self::y = intval(args[1]);
		}

		if (isset(args[2])) {
			let self::radius = intval(args[2]);
		}

		var output;
		let output = self::genColour();
		return output . "<?php imagearc($KBIMAGE, " . self::x . "," . self::y . "," . self::radius . "," . self::radius . ", 0, 360, $KBCOLOUR);?>";
	}
}
