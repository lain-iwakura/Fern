#ifndef INCLUDE_FERN_ABSTRACTPAINTER_HPP
#define INCLUDE_FERN_ABSTRACTPAINTER_HPP

#include <Fern/Export.hpp>
#include <Fern/PaintParamTypes.hpp>

namespace Fern{

class FERN_EXPORT AbstractPainter
{
public:
	virtual ~AbstractPainter();

	virtual void drawLine(const ScreenPoint& p1, const ScreenPoint& p2) = 0;

	virtual void drawLineF(const ScreenPointF& p1, const ScreenPointF& p2);

	//...

};

}

#endif // <- INCLUDE_FERN_ABSTRACTPAINTER_HPP
