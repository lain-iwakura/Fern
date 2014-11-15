#ifndef INCLUDE_FERN_PAINTPARAMTYPES_H
#define INCLUDE_FERN_PAINTPARAMTYPES_H

#include <Fern/Types.hpp>

namespace Fern{

struct ScreenPoint
{
	ScreenPoint(pxlnum _x = 0, pxlnum _y = 0) :
	x(_x), y(_y)
	{}

	pxlnum x;
	pxlnum y;
};

struct ScreenPointF
{
	ScreenPointF(pxlfnum _x = 0, pxlfnum _y = 0) :
	x(_x), y(_y)
	{}

	pxlfnum x;
	pxlfnum y;
};

struct Color
{
	Color(clrnum _r = 0, clrnum _g = 0, clrnum _b = 0, clrnum _a = 0) :
	r(_r), g(_g), b(_b), a(_a)
	{}

	clrnum r;
	clrnum g;
	clrnum b;
	clrnum a;
};

}

#endif // <- INCLUDE_FERN_PAINTPARAMTYPES_H
