#include "AbstractPainter.hpp"

namespace Fern
{

AbstractPainter::~AbstractPainter()
{
}

void AbstractPainter::drawLineF(const ScreenPointF& p1, const ScreenPointF& p2)
{
	drawLine(ScreenPoint(p1.x, p1.y), ScreenPoint(p2.x, p2.y));
}

}