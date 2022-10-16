from flutter import ComponentType

entity: ComponentType
dao: ComponentType
storage: ComponentType
service: ComponentType
page: ComponentType


def load():
    global entity, dao, storage, service, page
    entity = ComponentType("entity")
    dao = ComponentType("dao")
    storage = ComponentType("storage")
    service = ComponentType("service")
    page = ComponentType("page")
