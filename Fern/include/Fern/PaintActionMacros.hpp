#ifndef INCLUDE_FERN_PAINTACTIONMACROS_HPP
#define INCLUDE_FERN_PAINTACTIONMACROS_HPP

#define FERN_PAINTACTION_P0_DECLDEF(ClassName,funcName)                        \
class ClassName: public Fern::AbstractPaintAction                              \
{                                                                              \
public:                                                                        \
    void action(const Fern::AbstractPaintAction* painter) const                \
    {                                                                          \
        painter->funcName();                                                   \
    }                                                                          \
                                                                               \
    ClassName* clone() const                                                   \
    {                                                                          \
        return new ClassName(*this);                                           \
    }                                                                          \
};                                                                             

#define FERN_PAINTACTION_P1_DECLDEF(ClassName,funcName, type1,parName1)        \
class ClassName : public Fern::AbstractPaintAction                             \
{                                                                              \
public:                                                                        \
    ClassName(){}                                                              \
                                                                               \
    ClassName(const type1& _parName1) :                                        \
        parName1(_parName1)                                                    \
    {}                                                                         \
                                                                               \
    void action(const Fern::AbstractPaintAction* painter) const                \
    {                                                                          \
        painter->funcName(parName1);                                           \
    }                                                                          \
                                                                               \
    ClassName* clone() const                                                   \
    {                                                                          \
        return new ClassName(*this);                                           \
    }                                                                          \
                                                                               \
    type1 parName1;                                                            \
};                                                                             

#define FERN_PAINTACTION_P2_DECLDEF(ClassName,funcName, type1,parName1, type2,parName2)\
class ClassName : public Fern::AbstractPaintAction                             \
{                                                                              \
public:                                                                        \
    ClassName(){}                                                              \
                                                                               \
    ClassName(const type1& _parName1, const type2& _parName2) :                \
        parName1(_parName1), parName2(_parName2)                               \
    {}                                                                         \
                                                                               \
    void action(const Fern::AbstractPaintAction* painter) const                \
    {                                                                          \
        painter->funcName(parName1,parName2);                                  \
    }                                                                          \
                                                                               \
    ClassName* clone() const                                                   \
    {                                                                          \
        return new ClassName(*this);                                           \
    }                                                                          \
                                                                               \
    type1 parName1;                                                            \
    type2 parName2;                                                            \
};

#endif // <- INCLUDE_FERN_PAINTACTIONMACROS_HPP
