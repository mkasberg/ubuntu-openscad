/* 
The Ubuntu Logo!

Reference SVG from Wikimedia Commons:
https://commons.wikimedia.org/wiki/File:UbuntuCoF.svg

The reference SVG places the logo in the positive quadrant with a width and height of 100 (including a 5 unit margin on all sides).
In OpenSCAD, it's easier to center everything at the origin, so that's what we do below.

The Ubuntu Logo is Canonical IP.
The Canoncial IP Policy is available here (accessed 2023-02-11): https://ubuntu.com/legal/intellectual-property-policy
Your use of Canonical IP is subject to:
 - Your acceptance of this IPRights Policy;
 - Your acknowledgement that Canonical IP is the exclusive property of Canonical and can only be used with Canonical’s permission (which can be revoked at any time); and
 - You taking all reasonable steps to ensure that Canonical IP is used in a manner that does not affect either the validity of such Canonical IP or Canonical’s ownership of Canonical IP in any way; and that you will transfer any goodwill you derive from them to Canonical, if requested.

 ...
 You can use our copyright, patent and design materials in accordance with this IPRights Policy.
 ...
 Ubuntu is built by Canonical and the Ubuntu community. We share access rights owned by Canonical with the Ubuntu community for the purposes of discussion, development and advocacy. We recognise that most of the open source discussion and development areas are for non-commercial purposes and we therefore allow the use of Canonical IP in this context, as long as there is no commercial use and that the Canonical IP is used in accordance with this IPRights Policy.
*/

// The size (diameter) (mm)
size = 100;

// The thickness (mm)
thickness = 5;

// 0: All; 1: The friend ring logo; 2: Full logo with ring inside
type = 0;

// <g id="friend">
module friend_fill(thickness) {
  // <circle fill="#ffffff" cx="19.4" cy="50" r="6.00745"/>
  linear_extrude(thickness) translate([-50 + 19.4, 0, 0]) circle(r=6.00745);
}

// <g id="friend">
module friend_empty(thickness) {
  // <circle fill="#f47421" cx="19.4" cy="50" r="8.4376"/>
  translate([0, 0, -0.001]) linear_extrude(thickness + 0.002) translate([-50 + 19.4, 0, 0]) circle(r=8.4376);
  // <path stroke="#f47421" stroke-width="3.2378" d="M67,50H77"/>
  translate([0, 0, -0.001]) linear_extrude(thickness + 0.002) translate([-50 + 67, -3.2378/2, 0]) square([77, 3.2378]);
}

/**
 * @param size the total diameter
 */
module ubuntu_friend_ring(size, thickness=1) {
  default_size = (50 - 19.4 + 6.00745) * 2;
  scale([size / default_size, size / default_size, 1]) {
    difference() {
      // <circle fill="none" stroke="#ffffff" stroke-width="8.55" cx="50" cy="50" r="21.825"/>
      linear_extrude(thickness) {
        difference() {
          circle(r=21.825 + 8.55/2);
          circle(r=21.825 - 8.55/2);
        }
      }

      friend_empty(thickness);
      rotate(120) friend_empty(thickness);
      rotate(240) friend_empty(thickness);
    }

    friend_fill(thickness);
    rotate(120) friend_fill(thickness);
    rotate(240) friend_fill(thickness);
  }
}

module ubuntu_logo_empty(size, thickness=1) {
  friend_ring_size = (50 - 19.4 + 6.00745) * 2;
  scale([size/90, size/90, 1]) {
    difference() {
      // <circle fill="#f47421" cy="50" cx="50" r="45"/>
      linear_extrude(thickness) circle(r=45);
      
      translate([0, 0, -0.001]) ubuntu_friend_ring(friend_ring_size, thickness=thickness+.002);
    }
  }
}

if (type == 0) {
  // The Ubuntu Logo
  ubuntu_friend_ring(size, thickness);
  // The Ubuntu Logo inside a circle
  translate([size, 0, 0]) ubuntu_logo_empty(size, thickness);
} else if (type == 1) {
  // The Ubuntu Logo
  ubuntu_friend_ring(size, thickness);
} else {
  // The Ubuntu Logo inside a circle
  ubuntu_logo_empty(size, thickness);
}

