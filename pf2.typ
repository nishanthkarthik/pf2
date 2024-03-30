#let block_count = state("block_count", 0)
#let block_data = state("block_data", (:))

#let nest_to_key(nest) = {
    [$angle.l #nest.len() angle.r #nest.last()$]
}

#let tagsfn(..ls) = {
    let nest = arguments(..ls).pos();

    block_data.update(bldata => {
        if bldata.offset == () {
            bldata.offset = nest.len() - 1
        }
        bldata.nesting = nest.slice(bldata.offset, nest.len())
        bldata
    })

    locate(loc => {
        let nest = block_data.at(loc).nesting
        [$#nest_to_key(nest). $]
    })
}

// To override and refer labels anywhere
#let refer(xref) = {
    locate(loc => {
        let xrefs = query(xref, loc)
        if xrefs.len() == 0 {
            panic("missing label", xref)
        }
        if block_data.at(loc) == none {
            panic("reference outside a block", xref)
        }
        nest_to_key(block_data.at(xrefs.first().location()).nesting)
    })
}

// Refer the previous line at the same level
#let prev(i) = {
    locate(loc => {
        let this = block_data.at(loc).nesting
        let last = this.pop()
        this.push(last - i)
        nest_to_key(this)
    })
}

// Refer many previous lines at the same level
#let prevs(..i) = {
    let args = arguments(..i).pos().sorted().rev()
    args.map(prev).join(", ")
}

// Refer to parent (only for stating assumptions)
#let parent(n) = {
    locate(loc => {
        let this = block_data.at(loc).nesting
        if (n >= this.len()) {
            panic(this, "does not have", n, "parents")
        }
        nest_to_key(this.slice(0, this.len() - n))
    })
}

// Refer last n proof trees
#let prevn(n) = prevs(..array.range(1, n + 1))

#let is_xref_allowed(xref, from) = {
    // length of xref <= from
    if xref.len() > from.len() { return false }
    let from = from.slice(0, xref.len())
    let del = from.zip(xref).map(pair => pair.first() - pair.last())
    let signum = e => if e > 0 { 1 } else { 0 }
    (del.all(e => e >= 0)
        and del.any(e => e > 0)
        and del.map(signum).sum() == 1
        and del.sorted() == del)
}

// For use in proofs
#let showref(it) = {
    let el = it.element
    // May be none when partially rendered
    if el != none {
        let xref = el.location()
        // Only use refs inside blocks
        if block_data.at(xref) != none {
            // Only allow valid references
            locate(from => {
                let from_nest = block_data.at(from).nesting
                let xref_nest = block_data.at(xref).nesting
                if not is_xref_allowed(xref_nest, from_nest) {
                    panic("invalid reference from", from_nest, "to", xref_nest)
                }
                nest_to_key(block_data.at(xref).nesting)
            })
        }
    }
}

#let _block_spacing = 0.6em

#let blk(content) = {
    set enum(numbering: tagsfn, full: true, indent: 0em)
    show ref: showref
    show math.equation: set block(spacing: _block_spacing)
    show par: set block(spacing: _block_spacing)
    block_count.update(x => x + 1)
    block_data.update((nesting: (), offset: ()))
    content
    block_data.update(none)
}

#let stepkind(kind, content) = {
    set enum(numbering: "1.", start: 1, full: false)
    let key = smallcaps[#kind]
    block(spacing: _block_spacing, stack(dir: ltr, spacing: 0.25em, key, [:], content))
}

#let pf = smallcaps[Proof: ]
#let pfs = smallcaps[Proof sketch: ]
#let assume(content) = stepkind("Assume", content)
#let prove(content) = stepkind("Prove", content)
#let suffices(content) = stepkind("Suffices", content)
#let case(content) = stepkind("Case", content)
#let pflet(content) = stepkind("Let", content)
#let def(content) = stepkind("Define", content)
#let pick(content) = stepkind("Pick", content)
#let pfnew(content) = stepkind("New", content)
#let qed = "Q.E.D."
