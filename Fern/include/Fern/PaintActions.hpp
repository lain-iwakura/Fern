#ifndef INCLUDE_FERN_PAINTACTIONS_H
#define INCLUDE_FERN_PAINTACTIONS_H

#include <Fern/AbstractPaintAction.hpp>
#include <Fern/AbstractPainter.hpp>

namespace Fern{

FERN_PAINTACTION_P2_DECLDEF(PaintAction_drawLine, drawLine, ScreenPoint, p1, ScreenPoint, p2)

FERN_PAINTACTION_P2_DECLDEF(PaintAction_drawLineF, drawLineF, ScreenPointF, p1, ScreenPointF, p2)

}

#endif // <- INCLUDE_FERN_PAINTACTIONS_H
