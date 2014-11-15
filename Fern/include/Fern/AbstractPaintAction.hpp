#ifndef INCLUDE_FERN_ABSTRACTPAINTACTION_HPP
#define INCLUDE_FERN_ABSTRACTPAINTACTION_HPP

namespace Fern{

class AbstractPainter;

class AbstractPaintAction
{
public:
	virtual ~AbstractPaintAction() {}

	virtual void action(const AbstractPainter* painter) const = 0;

	virtual AbstractPaintAction* clone() const = 0;
};

}

#endif // <- INCLUDE_FERN_ABSTRACTPAINTACTION_HPP
