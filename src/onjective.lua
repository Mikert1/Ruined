local objective = {}
objective.list = {
    vines1 = {
        active = false,
        text = ""
    },
    vines2 = false,
    vines3 = false,
    vines4 = false,
}

objective.main = 

function objective.load()
    objective.state = 0
    objective.text = "Objective: Find the key to the door."
end

