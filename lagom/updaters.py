from typing import List, Type, Union

from lagom.definitions import SingletonWrapper, ConstructionWithoutContainer
from lagom.interfaces import ExtendableContainer, WriteableContainer, ReadableContainer


def update_container_singletons(
    container: Union[ExtendableContainer, WriteableContainer], singletons: List[Type]
):
    if isinstance(container, ExtendableContainer):
        new_container = container.clone()
    else:
        new_container = container
    for dep in singletons:
        _define_singleton_in_new_container(new_container, container, dep)
    return new_container


def _define_singleton_in_new_container(
    new_container: WriteableContainer, container: ReadableContainer, dep: Type
):
    new_container[dep] = SingletonWrapper(
        ConstructionWithoutContainer(lambda: container.resolve(dep))
    )
