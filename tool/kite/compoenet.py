from flutter import CompType

entity: CompType
dao: CompType
storage: CompType
service: CompType
page: CompType


def load():
    global entity, dao, storage, service, page
    entity = CompType("entity")
    dao = CompType("dao")
    storage = CompType("storage")
    service = CompType("service")
    page = CompType("page")
